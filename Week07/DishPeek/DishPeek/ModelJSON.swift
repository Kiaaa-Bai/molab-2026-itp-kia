import SwiftUI

extension Model {

    func saveAsJSON(fileName: String) {
        do {
            try saveJSON(fileName: fileName, val: self);
        }
        catch {
            fatalError("Model saveAsJSON error \(error)")
        }
    }

    init(JSONfileName fileName: String) {
        dishes = []
        do {
            self = try loadJSON(Model.self, fileName: fileName)
        } catch {
            print("Model init JSONfileName error \(error)")
        }
    }
}
