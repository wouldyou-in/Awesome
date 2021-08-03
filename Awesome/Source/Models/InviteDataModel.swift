import Foundation

// MARK: - InviteDataModel
struct InviteDataModel: Codable {
    let status, link: String
}


struct inviteCountDataModel: Codable {
    let invitations: [String]
}
