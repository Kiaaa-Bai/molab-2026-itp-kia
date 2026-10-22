import SwiftUI

@main
struct DishPeekApp: App {
    @State var document = Document()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(document)
        }
    }
}
