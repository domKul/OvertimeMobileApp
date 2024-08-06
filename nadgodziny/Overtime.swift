import Foundation

struct Overtime: Codable, Identifiable {
    var id: Int
    var creationDate: String
    var overtimeDate: String
    var status: String
    var duration: Int
}
