//error nil

import Foundation

extension Date {
    func toTimeString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale(identifier: "ru_RU") // по желанию
        return formatter.string(from: self)
    }
}
