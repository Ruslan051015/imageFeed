import Foundation

extension String {
    var dateFromString: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        return formatter.date(from: self)
    }
}
