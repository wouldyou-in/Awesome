//
//  KakaoLoginVC.swift
//  Awesome
//
//  Created by 박익범 on 2021/07/28.
//

import UIKit
import WebKit

class KakaoLoginVC: UIViewController {
    
    var webView: WKWebView!
    var loginURL : String = ""
    
    override func loadView() {
        super.loadView()
        webView = WKWebView(frame: self.view.frame)
        self.view = self.webView!
    }
//MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        webview()
    }
//MARK: func
//    func ifLoginSuccess() {
//        self.navigationController?.popViewController(animated: true)
//    }
    
    func setData(){
        GetKakaoLoginDataService.KakaoLoginData.getRecommendInfo{ (response) in
            switch(response)
            {
            case .success(let loginData):
                let defaults = UserDefaults.standard
                self.pushHome()
                defaults.set(true, forKey: "kakaoLoginSucces")
                defaults.set(true, forKey: "loginBool")
                defaults.set(loginData, forKey: "userToken")
                self.getAccessToken()
            case .requestErr(let message):
                print("requestERR")
            case .pathErr :
                print("pathERR")
            case .serverErr:
                print("serverERR")
            case .networkFail:
                print("networkFail")
            }
        }
    }
    
    func getAccessToken(){
        GetKakaoLoginTokenService.KakaoLoginToken.getRecommendInfo{ (response) in
            switch(response)
            {
            case .success(let loginData) :
                print("성공")
            case .requestErr(let message) :
                print("requestERR")
            case .pathErr :
                print("pathERR")
            case .serverErr:
                print("serverERR")
            case .networkFail:
                print("networkFail")
            }
        }
    }
    
    func pushHome(){
        guard let HomeVC = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(identifier: "HomeVC") as? HomeVC else {return}
        HomeVC.isFirstLoginBool = true
        self.navigationController?.pushViewController(HomeVC, animated: true)
       
    }

    
}
//MARK: Extension

extension KakaoLoginVC: WKNavigationDelegate{
    func webview(){
        let sURL = Constants.LoginURL
        let uURL = URL(string: sURL)
        let request = URLRequest(url: uURL!)
        webView.load(request)
        self.webView.navigationDelegate = self
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let urlString = webView.url?.absoluteString
        Constants.LoginURL = urlString!
        setData()
    }
}
