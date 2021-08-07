//
//  SplashVC.swift
//  Awesome
//
//  Created by 박익범 on 2021/07/29.
//

import UIKit

class SplashVC: UIViewController {
//MARK: Var
    @IBOutlet weak var splashImageView: UIImageView!
    static var isLoginSucces: Bool = false

//MARK: ViewDidLoad / viewDidAppear
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkDeviceNetworkStatus()
    }
    
//MARK: func
    func setPushView(){
        guard let homeVC = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeVC") as? HomeVC else {return}
        self.navigationController?.pushViewController(homeVC, animated: true)
    }
    
   
    
    func checkDeviceNetworkStatus() {
        guard let loginVC = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(identifier: "LoginVC") as? LoginVC else {return}
        //네트워크 이상없을때
        if(DeviceManager.shared.networkStatus) {
            if UserDefaults.standard.bool(forKey: "kakaoLoginSucces") == true {
                if SplashVC.isLoginSucces == true{
                    setPushView()
                }
            }
            else{
                self.navigationController?.pushViewController(loginVC, animated: true)
            }

            } else {
                let alert: UIAlertController = UIAlertController(title: "네트워크 상태 확인", message: "네트워크가 불안정 합니다.", preferredStyle: .alert)
                let action: UIAlertAction = UIAlertAction(title: "다시 시도", style: .default, handler: { (ACTION) in
                    self.checkDeviceNetworkStatus()
                })
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
            }
        }
// 토큰 업데이트 (접속시마다)
    static func getUpdateToken(){
        let defaults = UserDefaults.standard
        let refresh = defaults.string(forKey: "refreshToken")
        GetAutoLoginService.shared.AutoLoginService(refresh_token: refresh!) { [self] result in
            switch result{
            case .success(let tokenData):
                print("토큰 업데이트 성공")
                SplashVC.isLoginSucces = true
            case .requestErr(let msg):
                print("requestErr")
            default :
                print("ERROR")
            }
        }
    }
    
}

extension UIDevice {
    var hasNotch: Bool {
        let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
}
