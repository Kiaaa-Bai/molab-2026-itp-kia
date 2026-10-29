import SwiftUI

struct VideoView: View {
    @State var camera = VideoCamera()
    @State var layers: [FilterLayer] = []
    @State var showingSavedAlert = false

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            if camera.cameraMissing {
                Text("The camera needs a real iPhone.")
                    .foregroundStyle(.white)
            }
            FrameView(image: camera.previewImage)
                .ignoresSafeArea()
            VStack(spacing: 0) {
                Spacer()
                SlidersView()
                FilterChipsView()
                RecordButtonView()
            }
        }
        .task {
            await camera.start()
        }
        .onDisappear {
            camera.stop()
        }
        .onChange(of: layers) {
            camera.setLayers(layers)
        }
        .onChange(of: camera.videoSaved) { _, saved in
            if saved {
                showingSavedAlert = true
                camera.videoSaved = false
            }
        }
        .alert("Video saved to Photos", isPresented: $showingSavedAlert) {
        }
    }

    func toggle(_ effect: VideoEffect) {
        if let index = layers.firstIndex(where: { $0.effect == effect }) {
            layers.remove(at: index)
        } else {
            layers.append(FilterLayer(effect: effect))
        }
    }

    func SlidersView() -> some View {
        VStack(spacing: 4) {
            ForEach($layers) { $layer in
                HStack {
                    Text(layer.effect.rawValue)
                        .frame(width: 90, alignment: .leading)
                    Slider(value: $layer.amount, in: 0...1)
                }
            }
        }
        .foregroundStyle(.white)
        .padding(.horizontal)
        .padding(.vertical, layers.isEmpty ? 0 : 8)
        .background(Color.black.opacity(0.5))
    }

    func FilterChipsView() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 5) {
                ForEach(VideoEffect.allCases, id: \.self) { effect in
                    let index = layers.firstIndex(where: { $0.effect == effect })
                    Button {
                        toggle(effect)
                    } label: {
                        Text(index == nil ? effect.rawValue : "\(index! + 1) \(effect.rawValue)")
                            .padding(8)
                            .background(index == nil ? Color.gray.opacity(0.7) : Color.blue)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
            .padding()
        }
        .background(Color.black.opacity(0.5))
    }

    func RecordButtonView() -> some View {
        Button {
            if camera.isRecording {
                camera.stopRecording()
            } else {
                camera.startRecording()
            }
        } label: {
            Circle()
                .fill(camera.isRecording ? Color.red : Color.white)
                .frame(width: 70, height: 70)
                .padding()
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 2)
                        .frame(width: 80, height: 80)
                )
        }
        .disabled(camera.cameraMissing)
        .padding(.bottom, 5)
    }
}

#Preview {
    VideoView()
}
