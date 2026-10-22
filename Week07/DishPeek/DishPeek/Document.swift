import Foundation

@Observable
class Document {
    var model: Model

    let saveFileName = "dishes.json"

    init() {
        model = Model(JSONfileName: saveFileName);
        if model.dishes.isEmpty {
            model.dishes = Bundle.main.decode([Dish].self, from: "menu.json")
            saveModel();
        }
    }

    func addDish(dish: Dish) {
        model.addDish(dish: dish);
        saveModel();
    }

    func updateDish(dish: Dish) {
        model.updateDish(dish: dish);
        saveModel();
    }

    func deleteDish(id: UUID) {
        model.deleteDish(id: id)
        saveModel();
    }

    func saveModel() {
        model.saveAsJSON(fileName: saveFileName)
    }
}
