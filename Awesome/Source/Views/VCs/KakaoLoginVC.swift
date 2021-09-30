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
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    var isFinish: Bool = false

    
    override func loadView() {
        super.loadView()
        webView = WKWebView(frame: self.view.frame)
        self.view = self.webView!
    }
//MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        appdelegate.shouldSupportAllOrientation = false
        webview()
        webView.configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewdidappeaer")
    }
    override func viewDidDisappear(_ animated: Bool) {
        print("viewdiddisapper")
    }
    override func viewWillAppear(_ animated: Bool) {
        print("viewwillappear")
    }
    override func viewWillDisappear(_ animated: Bool) {
        print("viewwilldisappear")
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
                print("셋데이타에서 엑세스토큰 실행")
                self.getAccessToken()
            case .requestErr(let message):
                print("requestERR")
            case .pathErr:
                print("로그인 토큰 못받아옴")
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
                self.pushHome()
            case .requestErr(let message) :
                print("requestERR")
                print(Constants.loginString)
            case .pathErr :
                print("auth 토큰 못받아옴")
                print(Constants.loginString)
                print("pathERR")
            case .serverErr:
                print("serverERR")
                self.makeAlert(title: "알림", message: "탈퇴시 14일이내에 재가입이 불가능합니다.", okAction: {_ in self.navigationController?.popViewController(animated: true)}, completion: nil)
               
                print(Constants.loginString)
            case .networkFail:
                print("networkFail")
                print(Constants.loginString)

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

extension KakaoLoginVC: WKNavigationDelegate {
    func webview(){
        let sURL = Constants.LoginURL
        let uURL = URL(string: sURL)
        let request = URLRequest(url: uURL!)
        webView.load(request)
        self.webView.navigationDelegate = self
        self.webView.uiDelegate = self
        webView.customUserAgent = "Mozilla(iPhone; U; CPU iPhone OSlike Mac OS X; ja-jp) AppleWebKit/604.4.7 (KHTML, like Gecko) Version Mobile/8J2 Safari/6533.18.5";
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let urlString = webView.url?.absoluteString
        Constants.LoginURL = urlString!
        Constants.loginString = urlString!
        setData()
//        if UserDefaults.standard.bool(forKey: "kakaoLoginSucces") == true{
//            pushHome()
        
      
//        }
    }
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        print("받아온시점")
    }
}
extension KakaoLoginVC: WKUIDelegate{
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: webView.url?.host, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            completionHandler()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: webView.url?.host, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            completionHandler(false)
        }))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            completionHandler(true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print(navigationAction.request.url?.absoluteString ?? "")
        
        // 카카오링크 스킴인 경우 open을 시도합니다.
        if let url = navigationAction.request.url, url.scheme == "kakaotalk" {
            print("Execute kakaotalk!")
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            decisionHandler(.cancel)
            return
        }
        // 서비스 상황에 맞는 나머지 로직을 구현합니다.
        decisionHandler(.allow)
        let urlString = webView.url?.absoluteString
        Constants.loginString = urlString!
        getAccessToken()
//        if UserDefaults.standard.bool(forKey: "kakaoLoginSucces") == true {
//            print("따ㅣ옹")
//            pushHome()
//        }
    }
}
