import SwiftUI

struct ContentView: View {
    @Environment(Document.self) var document

    var body: some View {
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
    }
}

#Preview {
    ContentView()
        .environment(Document())
}
