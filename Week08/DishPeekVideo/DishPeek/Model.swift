import SwiftUI

struct Model: Codable {
    var dishes: [Dish]

    init () {
        dishes = [];
    }

    mutating func addDish(dish: Dish) {
        dishes.append(dish)
    }

    mutating func updateDish(dish: Dish) {
        if let index = findIndex(dish.id) {
            dishes[index] = dish;
        }
    }

    mutating func deleteDish(id: UUID) {
        if let index = findIndex(id) {
            dishes.remove(at: index)
        }
    }

    func findIndex(_ id: UUID) -> Int? {
        return dishes.firstIndex { dish in dish.id == id }
    }
}
