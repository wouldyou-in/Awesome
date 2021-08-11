//
//  AppDelegate.swift
//  Awesome
//
//  Created by 박익범 on 2021/07/27.
//

import UIKit
import AuthenticationServices

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var shouldSupportAllOrientation = true
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if shouldSupportAllOrientation == true{
            return UIInterfaceOrientationMask.all
        }
        else {
            return UIInterfaceOrientationMask.portrait
        }
    }
    func isAppleLogout(){
            if #available(iOS 13.0, *) {
                        let appleIDProvider = ASAuthorizationAppleIDProvider()
                appleIDProvider.getCredentialState(forUserID: UserDefaults.standard.string(forKey: "userID") ?? "") { (credentialState, error) in
                            switch credentialState {
                            case .authorized:
                                print("애플인증성공상태")
                            case .revoked:
                                print("애플인증만료")
                                let defaults = UserDefaults.standard
                                let refresh = defaults.string(forKey: "refreshToken")
                                GetLogoutService.shared.AutoLoginService(refresh_token: refresh!) { [self] result in
                                    switch result{
                                    case .success(let tokenData):
                                        print("로그아웃 성공")
                                        defaults.removeObject(forKey: "refreshToken")
                                        defaults.removeObject(forKey: "accessToken")
                                        defaults.removeObject(forKey: "name")
                                        defaults.removeObject(forKey: "profile")
                                        defaults.removeObject(forKey: "kakaoLoginSucces")
                                        defaults.removeObject(forKey: "appleLoginSuccess")
                                        defaults.setValue(false, forKey: "loginBool")
                                    case .requestErr(let msg):
                                        print("requestErr")
                                    default :
                                        print("ERROR")
                                    }
                                }                                //인증만료 상태
                            default:
                                print("에러")
                                //.notFound 등 이외 상태
                            }
                        }
                }
            
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        application.registerForRemoteNotifications()
        UNUserNotificationCenter.current().delegate = self
        print(UserDefaults.standard.bool(forKey: "loginBool"))
        if UserDefaults.standard.bool(forKey: "loginBool") == true{
            SplashVC.getUpdateToken()
            sleep(1)
        }
        else {
            sleep(1)
        }
        return true
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for notifications: \(error.localizedDescription)") }
    // 성공시
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) { let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        UserDefaults.standard.setValue(token, forKey: "deviceToken")
        print("Device Token: \(token)")
        
    }
    
    
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {

        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }


    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

