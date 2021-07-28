//
//  LoginVC.swift
//  Awesome
//
//  Created by 박익범 on 2021/07/28.
//

import UIKit

class LoginVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
//MARK: IBAction
    @IBAction func kakaoLoginButtonClicked(_ sender: Any) {
        guard let kakaoVC = UIStoryboard(name: "KakaoLogin", bundle: nil).instantiateViewController(identifier: "KakaoLoginVC") as? KakaoLoginVC else {return}
        self.navigationController?.pushViewController(kakaoVC, animated: true)
    }
    @IBAction func appleLoginButtonClicked(_ sender: Any) {
    }
    
}
