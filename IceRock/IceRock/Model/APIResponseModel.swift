import Foundation

struct APIResponseModel: Codable {
    let response: Album
}

struct Album: Codable {
    let count: Int
    let items: [Item]
}

struct Item: Codable {
    let date: Int
    let id: Int
    let sizes: [Size]
}

struct Size: Codable {
    let type: TypeEnum
    let url: String
}

enum TypeEnum: String, Codable {
    case m = "m"
    case o = "o"
    case p = "p"
    case q = "q"
    case r = "r"
    case s = "s"
    case w = "w"
    case x = "x"
    case y = "y"
    case z = "z"
}
