import SwiftUI

struct AddDishView: View {
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
                Button("Add") {
                    document.addDish(dish: dish)
                    dismiss()
                }
                Spacer()
                Button("Cancel") {
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
    AddDishView(dish: Dish())
        .environment(Document())
}
