import Foundation

struct Dish : Identifiable, Codable {
    var id = UUID()
    var name:String = ""
    var translation:String = ""
    var urlStr:String = ""
}
