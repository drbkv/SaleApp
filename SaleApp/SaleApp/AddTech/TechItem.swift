import UIKit
struct TechItem {
    var id: String
    var userId: String
    var category: Category
    var photos: [String]
    var brand: String
    var model: String
    var color: String
    var price: Int
    var description: String
    var status: Status
}

enum Category: String, CaseIterable {
    case smartphones = "Смартфоны"
    case laptops = "Ноутбуки"
    case tablets = "Планшеты"
    case televisions = "Телевизоры"
    case homeAppliances = "Бытовая техника"
}

enum Status: String, CaseIterable {
    case deleteListing = "Удалить"
    case archiveListing = "Архив"
    case inProgress = "На сайте"
}


