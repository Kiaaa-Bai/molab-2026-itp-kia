import SwiftUI

struct ContentView: View {
    @Environment(Mixer.self) var mixer

    var body: some View {
        TabView {
            StageView()
                .tabItem {
                    Label("Stage", systemImage: "hand.point.up")
                }

            MixerView(mixer: mixer)
                .tabItem {
                    Label("Mixer", systemImage: "slider.horizontal.3")
                }

            AlbumView()
                .tabItem {
                    Label("Album", systemImage: "photo")
                }
        }
        .onAppear {
            mixer.play()
        }
    }
}

#Preview {
    ContentView()
        .environment(Mixer())
}
