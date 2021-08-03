import Foundation

// MARK: - ProfileData
struct ProfileDataModel: Codable {
    let name: String
    let profileURL, thumbnailURL: String

    enum CodingKeys: String, CodingKey {
        case name
        case profileURL = "profile_url"
        case thumbnailURL = "thumbnail_url"
    }
}
