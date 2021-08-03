import Foundation

// MARK: - InviteDataModel
struct InviteCountDataModel: Codable {
    let status, link: String
}


struct inviteCountModel: Codable {
    let invitations: [String]
}
