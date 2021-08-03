// MARK: - 공용 변수를 저장할 파일입니다.

import Foundation

struct Constants {
    
    // MARK: - BASE URL
    static let baseURL = "https://api.wouldyou.in"
    
    // MARK: - Feature URL
    
    /// 1.로그인 리스트 URL
    static var LoginURL = baseURL + "/user/kakao/login/"
    static var updateLoginToken = baseURL + "/user/refresh/"
    static var logoutURL = baseURL + "/user/logout/"
    
    /// 2.프로필 리스트 URL
    static var profileDataURL = baseURL + "/user/me/"
    /// 3.약속 리스트 URL
    static var calendarURL = baseURL + "/calendar/"
    static var calendarAcceptURL = baseURL + "/calendar/accept/"
    static var postCalendearURL = baseURL + "/calendar/apply/"
    /// 4.초대장 URL
    static var inviteURL = baseURL + "/invite/link/"
    

}
