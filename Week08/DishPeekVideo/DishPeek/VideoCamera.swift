import AVFoundation
import CoreImage
import Photos
import SwiftUI

@Observable
nonisolated final class VideoCamera: NSObject, @unchecked Sendable {
    var previewImage: CGImage?
    var cameraMissing = false
    var isRecording = false
    var videoSaved = false

    @ObservationIgnored let session = AVCaptureSession()
    @ObservationIgnored private let queue = DispatchQueue(label: "videoQueue")
    @ObservationIgnored private let context = CIContext()
    @ObservationIgnored private var isConfigured = false

    @ObservationIgnored private let lock = NSLock()
    @ObservationIgnored private var layers: [FilterLayer] = []

    @ObservationIgnored private var wantsRecording = false
    @ObservationIgnored private var writer: AVAssetWriter?
    @ObservationIgnored private var writerInput: AVAssetWriterInput?
    @ObservationIgnored private var adaptor: AVAssetWriterInputPixelBufferAdaptor?
    @ObservationIgnored private let movieURL = FileManager.default.temporaryDirectory.appendingPathComponent("video.mp4")

    func setLayers(_ newLayers: [FilterLayer]) {
        lock.withLock {
            layers = newLayers
        }
    }

    func start() async {
        guard AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) != nil else {
            cameraMissing = true
            return
        }
        guard await AVCaptureDevice.requestAccess(for: .video) else {
            print("Camera access denied")
            return
        }
        queue.async {
            if !self.isConfigured {
                self.configure()
            }
            self.session.startRunning()
        }
    }

    func stop() {
        if isRecording {
            stopRecording()
        }
        queue.async {
            self.session.stopRunning()
        }
    }

    private func configure() {
        session.beginConfiguration()
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let input = try? AVCaptureDeviceInput(device: device),
              session.canAddInput(input) else {
            session.commitConfiguration()
            return
        }
        session.addInput(input)

        let output = AVCaptureVideoDataOutput()
        output.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
        output.setSampleBufferDelegate(self, queue: queue)
        if session.canAddOutput(output) {
            session.addOutput(output)
        }

        if let connection = output.connection(with: .video), connection.isVideoRotationAngleSupported(90) {
            connection.videoRotationAngle = 90
        }
        session.commitConfiguration()
        isConfigured = true
    }

    func startRecording() {
        isRecording = true
        queue.async {
            self.wantsRecording = true
        }
    }

    func stopRecording() {
        isRecording = false
        queue.async {
            self.wantsRecording = false
            guard let writer = self.writer else { return }
            self.writerInput?.markAsFinished()
            writer.finishWriting {
                self.saveToPhotos()
            }
            self.writer = nil
            self.writerInput = nil
            self.adaptor = nil
        }
    }

    private func startWriter(width: Int, height: Int, time: CMTime) {
        try? FileManager.default.removeItem(at: movieURL)
        guard let writer = try? AVAssetWriter(outputURL: movieURL, fileType: .mp4) else {
            print("Could not create AVAssetWriter")
            wantsRecording = false
            return
        }
        let input = AVAssetWriterInput(mediaType: .video, outputSettings: [
            AVVideoCodecKey: AVVideoCodecType.h264,
            AVVideoWidthKey: width,
            AVVideoHeightKey: height
        ])
        input.expectsMediaDataInRealTime = true
        let adaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: input, sourcePixelBufferAttributes: [
            kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA),
            kCVPixelBufferWidthKey as String: width,
            kCVPixelBufferHeightKey as String: height
        ])
        writer.add(input)
        writer.startWriting()
        writer.startSession(atSourceTime: time)
        self.writer = writer
        self.writerInput = input
        self.adaptor = adaptor
    }

    private func record(_ image: CIImage, time: CMTime) {
        if writer == nil {
            startWriter(width: Int(image.extent.width), height: Int(image.extent.height), time: time)
        }
        guard let writerInput, writerInput.isReadyForMoreMediaData,
              let adaptor, let pool = adaptor.pixelBufferPool else { return }
        var buffer: CVPixelBuffer?
        CVPixelBufferPoolCreatePixelBuffer(nil, pool, &buffer)
        guard let buffer else { return }
        context.render(image, to: buffer)
        adaptor.append(buffer, withPresentationTime: time)
    }

    private func saveToPhotos() {
        PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
            guard status == .authorized || status == .limited else {
                print("Photo library access denied")
                return
            }
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: self.movieURL)
            }) { saved, error in
                if let error {
                    print("Error saving video to library:", error)
                }
                DispatchQueue.main.async {
                    self.videoSaved = saved
                }
            }
        }
    }
}

extension VideoCamera: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        let currentLayers = lock.withLock { layers }
        let image = CIImage(cvPixelBuffer: pixelBuffer)
        let filtered = applyFilters(image, layers: currentLayers)

        if let cgImage = context.createCGImage(filtered, from: image.extent) {
            DispatchQueue.main.async {
                self.previewImage = cgImage
            }
        }
        if wantsRecording {
            record(filtered, time: CMSampleBufferGetPresentationTimeStamp(sampleBuffer))
        }
    }
}
