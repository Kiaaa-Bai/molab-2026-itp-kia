import SwiftUI

@main
struct PGONEApp: App {
    @State var mixer = Mixer()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(mixer)
        }
    }
}
