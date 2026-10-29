import SwiftUI

struct UpdateDishView: View {
    @State var dish: Dish

    @Environment(\.dismiss) var dismiss
    @Environment(Document.self) var document

    var body: some View {
        VStack {
            AsyncImage(url: URL(string: dish.urlStr)) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else if phase.error != nil {
                    Color.red
                } else {
                    Color.clear
                }
            }
            HStack {
                Button("Update") {
                    document.updateDish(dish: dish)
                    dismiss()
                }
                Spacer()
                Button("Delete") {
                    document.deleteDish(id: dish.id)
                    dismiss()
                }
            }.padding(10)
            Form {
                TextField("menu name", text: $dish.name)
                TextField("translation", text: $dish.translation)
                TextField("image url", text: $dish.urlStr)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
            }
        }
    }
}

#Preview {
    UpdateDishView(dish: Dish())
        .environment(Document())
}
