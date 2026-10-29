import SwiftUI

struct ContentView: View {
    @Environment(Document.self) var document

    var body: some View {
        TabView {
            NavigationStack {
                List {
                    ForEach(document.model.dishes) { dish in
                        NavigationLink(destination: UpdateDishView(dish: dish)) {
                            DishRow(dish: dish)
                        }
                    }
                }
                .navigationTitle("Menu")
                .toolbar {
                    NavigationLink(destination: ScanMenuView()) {
                        Text("Scan Menu")
                    }
                    NavigationLink(destination: AddDishView(dish: Dish())) {
                        Text("Add Dish")
                    }
                }
            }
            .tabItem {
                Label("Menu", systemImage: "menucard")
            }

            VideoView()
                .tabItem {
                    Label("Video", systemImage: "video")
                }
        }
    }
}

#Preview {
    ContentView()
        .environment(Document())
}
