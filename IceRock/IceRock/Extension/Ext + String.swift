import Foundation

public extension String {
    static var empty: Self { "" }
    static var space: Self { " " }
    static var comma: Self { "," }
    static var slash: Self { "/" }
    static var dot: Self { "." }
    static var grid: Self { "#" }
    static var ampersand: Self { "&" }
    static var z: Self { "z" }
    static var equals: Self { "=" }
    static var plus: Self { "+" }
    static var minus: Self { "-" }
    static var question: Self { "?" }
}

public extension String {
    func localized() -> String {
        return NSLocalizedString(
            self,
            tableName: "Localizable",
            bundle: .main,
            value: self,
            comment: self
        )
    }
}
