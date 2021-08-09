import Foundation
// MARK: - UserAccesCode
struct KakaoLoginDataModel: Codable {
    let code: String
}

struct KakaoLoginTokenModel: Codable {
    let accessToken, refreshToken: String
    let user: User

    enum CodingKeys: String, CodingKey {
        case user
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}
struct User: Codable {
    let id: Int
    let name: String
}
