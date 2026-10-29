import SwiftUI

struct DishRow: View {
    var dish: Dish

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: dish.urlStr)) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else if phase.error != nil {
                    Color.red
                } else {
                    Color.gray
                }
            }
            .frame(width: 70, height: 70)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.gray, lineWidth: 2))

            VStack(alignment: .leading) {
                Text(dish.name)
                    .font(.headline)
                Text(dish.translation)
            }
        }
    }
}

#Preview {
    DishRow(dish: Dish(name: "비빔밥", translation: "Bibimbap — mixed rice with vegetables"))
}
