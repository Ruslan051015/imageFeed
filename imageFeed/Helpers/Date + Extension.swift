import Foundation

extension Date {
    var stringFromDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        
        return formatter.string(from: self)}
}
