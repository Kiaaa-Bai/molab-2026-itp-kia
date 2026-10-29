import PhotosUI
import SwiftUI
import Vision

struct ScanMenuView: View {
    @State private var selectedItem: PhotosPickerItem?
    @State private var imageData: Data?

    @State private var lines: [String] = []
    @State private var isReading = false

    var body: some View {
        List {
            Section {
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    if let imageData, let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                    } else {
                        ContentUnavailableView("No menu photo", systemImage: "menucard", description: Text("Tap to pick a photo of a menu"))
                    }
                }
                .buttonStyle(.plain)
                .onChange(of: selectedItem, loadImage)

                if imageData != nil {
                    Button(isReading ? "Reading…" : "Read Menu Text") {
                        Task { await readText() }
                    }
                    .disabled(isReading)
                }
            }

            if !lines.isEmpty {
                Section("Found \(lines.count) lines — tap one to add it") {
                    ForEach(lines, id: \.self) { line in
                        NavigationLink(destination: AddDishView(dish: Dish(name: line))) {
                            Text(line)
                        }
                    }
                }
            }
        }
        .navigationTitle("Scan Menu")
    }

    func loadImage() {
        Task {
            imageData = try? await selectedItem?.loadTransferable(type: Data.self)
            lines = []
        }
    }

    func readText() async {
        guard let imageData else { return }
        guard let image = CIImage(data: imageData, options: [.applyOrientationProperty: true]) else { return }
        isReading = true

        var request = RecognizeTextRequest()
        request.recognitionLevel = .accurate
        request.recognitionLanguages = [Locale.Language(identifier: "ko-KR"), Locale.Language(identifier: "en-US")]

        do {
            let observations = try await request.perform(on: image)
            let priceCharacters = CharacterSet(charactersIn: "0123456789,.₩$ ")
            lines = observations.compactMap { observation in
                observation.topCandidates(1).first?.string
            }
            .map { line in line.trimmingCharacters(in: priceCharacters) }
            .filter { line in !line.isEmpty }
        } catch {
            lines = ["Could not read text: \(error.localizedDescription)"]
        }

        isReading = false
    }
}

#Preview {
    NavigationStack {
        ScanMenuView()
            .environment(Document())
    }
}
