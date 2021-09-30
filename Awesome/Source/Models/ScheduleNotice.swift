import Foundation


// MARK: - ScheduleNoticeModel
struct ScheduleNoticeModel: Codable {
    let status: String
    let calendars: [ScheduleNoticeDataModel]
    
}


// MARK: - ScheduleNoticeDataModel
struct ScheduleNoticeDataModel: Codable {
       let id: Int
       let creator: Int?
       let participant: Int
       let creatorName: String
       let creatorEmail: String?
       let participantName, comment: String
       let startDate, endDate: String
       let createdAt: String
       let isAccept: Bool?

       enum CodingKeys: String, CodingKey {
           case id, creator, participant
           case creatorName = "creator_name"
           case creatorEmail = "creator_email"
           case participantName = "participant_name"
           case comment
           case startDate = "start_date"
           case endDate = "end_date"
           case createdAt = "created_at"
           case isAccept = "is_accept"
       }


}
