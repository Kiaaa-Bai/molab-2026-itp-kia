import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HeartsView()
                .tabItem {
                    Label("Hearts", systemImage: "heart")
                }

            MahjongView()
                .tabItem {
                    Label("Mahjong", systemImage: "square.grid.2x2")
                }
        }
    }
}

#Preview {
    ContentView()
}
