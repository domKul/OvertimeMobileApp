import Foundation

struct OvertimeCreateDto: Codable {
    let overtimeDate: String
    let status: String
    let duration: Int
}
