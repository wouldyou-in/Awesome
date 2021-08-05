import Foundation

// MARK: - Welcome
struct BlockDataModel: Codable {
    let block: [Block]
}

// MARK: - Block
struct Block: Codable {
    let id, creator: Int
    let startDate, endDate: String

    enum CodingKeys: String, CodingKey {
        case id, creator
        case startDate = "start_date"
        case endDate = "end_date"
    }
}
