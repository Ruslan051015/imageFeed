import Foundation

final class DateService {
    // MARK: - Properties:
    static let shared = DateService()
    
    // MARK: - Private properties:
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    private let isoDateFormatter = ISO8601DateFormatter()
    
    // MARK: - Methods:
    func dateFromText(_ string :String?) -> Date? {
        guard
            let string = string,
            let date = isoDateFormatter.date(from: string) else {
            return nil
        }
        return date
    }
    
    func stringFromDate(date: Date?) -> String? {
        guard let date = date else {
            return nil
        }
        return dateFormatter.string(from: date)
    }
    
    // MARK: - Private methods:
    private init() { }
}
