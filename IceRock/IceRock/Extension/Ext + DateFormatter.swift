import Foundation

extension DateFormatter {
    static let titleDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM YYYY"
        let currentLocale = Locale.current.identifier
        dateFormatter.locale = Locale(identifier: currentLocale)
        return dateFormatter
    }()
}
