// MARK: - 공용 변수를 저장할 파일입니다.

import Foundation

struct Constants {
    
    // MARK: - BASE URL
    static let baseURL = "https://api.wouldyou.in"
    
    // MARK: - Feature URL
    static var loginString = "https://api.wouldyou.in/user/kakao/callback/"
    /// 1.로그인 리스트 URL
    static var LoginURL = baseURL + "/user/kakao/login/"
    static var updateLoginToken = baseURL + "/user/refresh/"
    static var logoutURL = baseURL + "/user/logout/"
    static var appleLogin = baseURL + "/user/apple/login/"
    static var withdraw = baseURL + "/user/quit/"
    /// 2.프로필 리스트 URL
    static var profileDataURL = baseURL + "/user/me/"
    /// 3.약속 리스트 URL
    static var calendarURL = baseURL + "/calendar/"
    static var calendarAcceptURL = baseURL + "/calendar/accept/"
    static var postCalendearURL = baseURL + "/calendar/apply/"
    static var blockDateURL = baseURL + "/calendar/block/"
    /// 4.초대장 URL
    static var inviteURL = baseURL + "/invite/link/"
    /// 5. APNs URL
    static var deviceTokenURL = baseURL + "/push/ios/"
    

}
