//
//  SettingVC.swift
//  Awesome
//
//  Created by 박익범 on 2021/07/28.
//

import UIKit
import AuthenticationServices


class SettingVC: UIViewController {
//MARK: IBOulet
    
    @IBOutlet var backGroundView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var leftInviteLabel: UILabel!
    @IBOutlet weak var leftInviteView: UIView!
    @IBOutlet weak var linkshareView: UIView!
    @IBOutlet weak var notificationView: UIView!
    @IBOutlet weak var LogoutView: UIView!
    @IBOutlet weak var withdrawView: UIView!
    @IBOutlet weak var shareLabel: UILabel!
    @IBOutlet weak var linkShareButton: UIButton!
    @IBOutlet weak var toggle: UISwitch!
    
//MARK: Var
    var leftInviteCountText: Int = 0
    var inviteLink: [String] = []
    var invite: String = ""
    var intInviteCount: Int = 0
    var inviteCount: [InviteCountDataModel] = []
    var notiPermission: Bool = false
    let appdelegate = UIApplication.shared.delegate as! AppDelegate

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setHeaderView()
        setButtonView()
        getInviteCount()
        isToggleOn()
    }
//MARK: Function
    func setHeaderView(){
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        appdelegate.shouldSupportAllOrientation = false
        backGroundView.backgroundColor = UIColor.mainGray
        headerView.backgroundColor = UIColor.mainGray
        leftInviteLabel.font = UIFont.gmarketSansMediumFont(ofSize: 12)
        leftInviteView.clipsToBounds = true
        leftInviteView.layer.cornerRadius = 15
        leftInviteLabel.text = "남은 초대장 : \(leftInviteCountText)"
    }
    func setButtonView(){
        linkshareView.clipsToBounds = true
        linkshareView.layer.cornerRadius = 15
        notificationView.clipsToBounds = true
        notificationView.layer.cornerRadius = 15
        LogoutView.clipsToBounds = true
        LogoutView.layer.cornerRadius = 15
        withdrawView.clipsToBounds = true
        withdrawView.layer.cornerRadius = 15
    }
    func isToggleOn(){
        if UserDefaults.standard.bool(forKey: "noti") == true{
            toggle.setOn(true, animated: true)
        }
    }
//MARK: IBAction
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func inviteButtonClicked(_ sender: Any) {
        getInvite()
        if intInviteCount == 0{
            let alert = UIAlertController(title: "공유 불가", message: "사용가능한 초대장을 전부 사용하셨습니다.", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "확인", style: .default)
            {(action) in}
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
        
        else{
        let alert = UIAlertController(title: "초대장 공유", message: "초대장을 다른 사람들에게 공유하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
            let activityVC = UIActivityViewController(activityItems: self.inviteLink, applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = self.view
            
            if let popoverController = activityVC.popoverPresentationController {
                popoverController.sourceView = self.view //to set the source of your alert
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0) // you can set this as per your requirement.
                popoverController.permittedArrowDirections = [] //to hide the arrow of any particular direction
            }
            
            self.present(activityVC, animated: true, completion: nil)
            
            activityVC.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, arrayReturnedItems: [Any]?, error: Error?) in if completed { }
            else { self.deleteInvite() }
                if let shareError = error { } }

        }
        let cancelAction = UIAlertAction(title: "취소", style: .default)
        {(action) in
            self.deleteInvite()
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func notificationToggleClicked(_ sender: Any) {
        UNUserNotificationCenter.current().delegate = self
        if toggle.isOn{
            
            if notiPermission == false{if let appSetting = URL(string: UIApplication.openSettingsURLString){
                UIApplication.shared.open(appSetting, options: [:], completionHandler: nil)
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge], completionHandler: {didAllow,Error in
                    self.notiPermission = didAllow
                    UserDefaults.standard.setValue(didAllow, forKey: "noti")
                })
            }}
            
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge], completionHandler: {didAllow,Error in
                self.notiPermission = didAllow
                UserDefaults.standard.setValue(didAllow, forKey: "noti")
            })
        }
        else{
            if let appSetting = URL(string: UIApplication.openSettingsURLString){
                UIApplication.shared.open(appSetting, options: [:], completionHandler: nil)
                UserDefaults.standard.setValue(notiPermission, forKey: "noti")
            }
        }
    }
    
    
    @IBAction func linkShareButtonClicked(_ sender: Any) {
        var objectsToShare = [String]()
        objectsToShare.append("나의 어떰 프로필을 공유합니다.")
//        if let text = shareLabel.text{
//                   objectsToShare.append(text)
//                   print("[INFO] textField's Text : ", text)
//               }
               let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
               activityVC.popoverPresentationController?.sourceView = self.view
               self.present(activityVC, animated: true, completion: nil)
        
        if let popoverController = activityVC.popoverPresentationController {
            popoverController.sourceView = self.view //to set the source of your alert
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0) // you can set this as per your requirement.
            popoverController.permittedArrowDirections = [] //to hide the arrow of any particular direction
        }
    }
    
    
    
    @IBAction func logoutButtonClicked(_ sender: Any) {
        let alert = UIAlertController(title: "로그아웃", message: "로그아웃하여 초기화면으로 이동합니다.", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
            
            
            if UserDefaults.standard.bool(forKey: "appleLoginSuccess") == true{
                if #available(iOS 13.0, *) {
                            let appleIDProvider = ASAuthorizationAppleIDProvider()
                    appleIDProvider.getCredentialState(forUserID: UserDefaults.standard.string(forKey: "userID")!) { (credentialState, error) in
                                switch credentialState {
                                case .authorized:
                                    print("인증성공상태")
                                    DispatchQueue.main.async {
                                        self.makeAlert(title: "로그아웃 실패", message: "내 설정에서 로그아웃을 해주세요.")
                                    }
//                                    if let appSetting = URL(string: UIApplication.openSettingsURLString){
//                                        UIApplication.shared.open(appSetting, options: [:], completionHandler: nil)
//                                    }
                                    
                                    //인증성공 상태
                                case .revoked:
                                    print("인증만료")
                                    self.logOutFunction()
                                    //인증만료 상태
                                default:
                                    print("에러")
                                    //.notFound 등 이외 상태
                                }
                            }
                    }
                }
            //애플로그인 아닐때
            else{
                self.logOutFunction()
            }



        }
        let cancelAction = UIAlertAction(title: "취소", style: .default)
        {(action) in
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    @IBAction func withdrawButtonClicked(_ sender: Any) {
        PostDevieceTokenDataService.shared.AutoLoginService(push_token: UserDefaults.standard.string(forKey: "deviceToken")!) { [self] result in
            switch result{
            case .success(let tokenData):
                print("성공")
            case .requestErr(let msg):
                print("requestErr")
            default :
                print("ERROR")
            }
        }
        
        
        
        
    }
//MARK: function
    func logOutFunction(){
        guard let resetVC = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(identifier: "LoginVC") as? LoginVC else {return}
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
                self.navigationController?.pushViewController(resetVC, animated: true)
            case .requestErr(let msg):
                print("requestErr")
            default :
                print("ERROR")
            }
        }
    }
    
    
    
    func append(){
        inviteLink.append("📩 \(UserDefaults.standard.string(forKey: "name")!)님께서 '어떰'의 초대장을 보내셨습니다!\n\n '어떰'은 개인링크로 일정📅을 공유해 간편하게 약속을 잡을 수 있는 서비스입니다.\n\n ✉ 초대링크: \(invite) \n\n😝잉여 시간에 약속신청 받고 놀러가자😝")
    }
    func getInviteCount(){
        GetInviteCountService.inviteCountData.getRecommendInfo{ (response) in
            switch(response)
            {
            case .success(let inviteData):
                if let response = inviteData as? InviteCountDataModel{
                    let inviteCount = 3 - response.invitations.count
                    self.intInviteCount = inviteCount
                    self.leftInviteLabel.text = "남은 초대장 : \(inviteCount)"
                }
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
    func getInvite(){
        GetInviteService.inviteData.getRecommendInfo{ (response) in
            switch(response)
            {
            case .success(let inviteData):
                if let response = inviteData as? InviteDataModel{
                    DispatchQueue.main.async {
                        self.invite.append(response.link)
                        self.append()
                    }
                }
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
    
    func deleteInvite(){
        let inviteToken = invite.components(separatedBy: "/")
        print(inviteToken)
        DeleteInviteData.shared.DeleteService(invitation_token: inviteToken[4]) { [self] result in
                switch result{
                case .success(let tokenData):
                    print("삭제 성공")
                case .requestErr(let msg):
                    print("requestErr")
                default :
                    print("ERROR")
                }
            }
    }

}
extension SettingVC: UNUserNotificationCenterDelegate{
    
}

extension SettingVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
