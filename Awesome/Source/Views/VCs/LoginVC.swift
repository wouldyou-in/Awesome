//
//  LoginVC.swift
//  Awesome
//
//  Created by 박익범 on 2021/07/28.
//

import UIKit
import AuthenticationServices

class LoginVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        appdelegate.shouldSupportAllOrientation = false
    }
    @IBOutlet weak var loginImageView: UIImageView!
    
    var appleToken: String = ""
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    var appleName: String = ""

//
//    func setImage(){
//        if UIDevice.current.hasNotch {
//            //... 노치가 있을때....
//            if UIScreen.main.bounds.width > 500 {
//                loginImageView.image = UIImage(named: "iPadLogin")
//            }
//            else{
//                loginImageView.image = UIImage(named: "loginBackground")
//            }
//        } else {
//            //... 노치가 없을때...
//            if UIScreen.main.bounds.width > 500{
//                loginImageView.image = UIImage(named: "iPadLogin")
//            }
//            else{
//                loginImageView.image = UIImage(named: "iPhone8Login")
//            }
//        }
//    }
    
    
    //MARK: IBAction
    @IBAction func kakaoLoginButtonClicked(_ sender: Any) {
        guard let kakaoVC = UIStoryboard(name: "KakaoLogin", bundle: nil).instantiateViewController(identifier: "KakaoLoginVC") as? KakaoLoginVC else {return}
        self.navigationController?.pushViewController(kakaoVC, animated: true)
    }
    @IBAction func appleLoginButtonClicked(_ sender: Any) {
        let request = ASAuthorizationAppleIDProvider().createRequest()
               request.requestedScopes = [.fullName, .email]
        
               let controller = ASAuthorizationController(authorizationRequests: [request])
               controller.delegate = self as? ASAuthorizationControllerDelegate
               controller.presentationContextProvider = self as? ASAuthorizationControllerPresentationContextProviding
               controller.performRequests()
    }
    
}

extension LoginVC: ASAuthorizationControllerDelegate{
    // 성공 후 동작
        func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
            
            if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
//                guard let LoginCompletVC = storyboard?.instantiateViewController(identifier: "LoginViewController") as? LoginViewController else {return}
//                navigationController?.pushViewController(LoginCompletVC, animated: true)
        
                let idToken = credential.identityToken!
                let tokeStr = String(data: idToken, encoding: .utf8)
                print("호호",tokeStr)

                guard let code = credential.authorizationCode else { return }
                let codeStr = String(data: code, encoding: .utf8)
                appleToken = codeStr ?? "오류"
                print("호호", codeStr)

                let user = credential.fullName
                let userIdentifier = credential.user
                UserDefaults.standard.setValue(userIdentifier, forKey: "userID")
                var familyName = user?.familyName ?? ""
                var givenName = user?.givenName ?? ""
                appleName = familyName + givenName
                UserDefaults.standard.setValue(appleName, forKey: "appleName")
                self.dismiss(animated: true, completion: nil)
                
                    AppleLoginService.shared.postScheduleService(code: appleToken, name: UserDefaults.standard.string(forKey: "appleName") ?? "") { [self] result in
                        switch result{
                        case .success(let tokenData):
                            guard let homeVC = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(identifier: "HomeVC") as? HomeVC else {return}
                            self.navigationController?.pushViewController(homeVC, animated: true)
                            print("성공")
                        case .requestErr(let msg):
                            print("requestErr")
                        default :
                            print("ERROR")
                        }
                    }


            }
            
        }
    
        // 실패 후 동작
        func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
            print("error")
        }
}
