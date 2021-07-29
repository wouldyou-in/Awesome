
import Foundation

// MARK: - AutoLoginDataModel
struct AutoLoginDataModel: Codable {
    let accesstoken: String

    enum CodingKeys: String, CodingKey {
        case accesstoken = "access_token"
    }
}
