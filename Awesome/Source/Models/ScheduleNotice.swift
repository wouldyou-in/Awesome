import Foundation

public protocol DefaultCodableStrategy {
    associatedtype DefaultValue: Decodable
    
    /// The fallback value used when decoding fails
    static var defaultValue: DefaultValue { get }
}

public struct DefaultFalseStrategy: DefaultCodableStrategy {
    public static var defaultValue: Bool { return false }
}

// MARK: - ScheduleNoticeModel
struct ScheduleNoticeModel: Codable {
    let status: String
    let calendars: [ScheduleNoticeDataModel]
    
}


// MARK: - ScheduleNoticeDataModel
struct ScheduleNoticeDataModel: Codable {
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

//    init(from decoder : Decoder) throws
//        {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        id = (try? values.decode(Int.self, forKey: .id)) ?? 0
//        creator = (try? values.decode(Int.self, forKey: .creator)) ?? 0
//        creatorName = (try? values.decode(String.self, forKey: .creatorName)) ?? ""
//        participant = (try? values.decode(Int.self, forKey: .participant)) ?? 0
//        participantName = (try? values.decode(String.self, forKey: .participantName)) ?? ""
//        comment = (try? values.decode(String.self, forKey: .comment)) ?? ""
//        startDate = (try? values.decode(Date.self, forKey: .startDate)) ?? Date()
//        endDate = (try? values.decode(Date.self, forKey: .endDate)) ?? Date()
//        createdAt = (try? values.decode(String.self, forKey: .createdAt)) ?? ""
//        isAccept = (try? values.decode(Bool.self, forKey: .isAccept)) ?? false
//        }
}
