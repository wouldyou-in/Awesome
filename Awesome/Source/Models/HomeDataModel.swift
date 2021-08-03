
import Foundation

// MARK: - CalendarDataModel
struct CalendarDataModel: Codable {
    let createdCalendar, myCalendar, calendar: [MyCalendar]

    enum CodingKeys: String, CodingKey {
        case createdCalendar = "created_calendar"
        case myCalendar = "my_calendar"
        case calendar
    }
}

// MARK: - Calendar
struct MyCalendar: Codable {
    let creatorName: String
    let participantName: String
    let id, creator, participant: Int
    let comment: String
    let startDate, endDate: Date
    let createdAt: String
    let isAccept: Bool

    enum CodingKeys: String, CodingKey {
        case id, creator, participant, comment
        case creatorName = "creator_name"
        case participantName = "participant_name"
        case startDate = "start_date"
        case endDate = "end_date"
        case createdAt = "created_at"
        case isAccept = "is_accept"

    }
}

