import Foundation

// MARK: - Welcome
struct InviteCountDataModel: Codable {
    let invitations: [inviteCountModel]
}

// MARK: - Invitation
struct inviteCountModel: Codable {
    let invitationToken: String
    let isUsed: Bool

    enum CodingKeys: String, CodingKey {
        case invitationToken = "invitation_token"
        case isUsed = "is_used"
    }
}
