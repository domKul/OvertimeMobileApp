import Foundation

struct OvertimeResponseDto: Codable {
    let id: Int
    let creationDate: String // JSON używa formatu "yyyy-MM-dd"
    let overtimeDate: String // JSON używa formatu "yyyy-MM-dd"
    let status: String
    let duration: Int
}
