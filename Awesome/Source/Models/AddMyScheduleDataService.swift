import Foundation

// MARK: - Welcome
struct PostCalendarDataModel: Codable {
    let status: String
    let data: PostCalendar
}

// MARK: - DataClass
struct PostCalendar: Codable {
    let id, creator: Int
    let creatorName: String
    let participant: Int
    let participantName, comment: String
    let startDate, endDate: Date
    let createdAt: String
    let isAccept: Bool?

    enum CodingKeys: String, CodingKey {
        case id, creator
        case creatorName = "creator_name"
        case participant
        case participantName = "participant_name"
        case comment
        case startDate = "start_date"
        case endDate = "end_date"
        case createdAt = "created_at"
        case isAccept = "is_accept"
        
    }
}
