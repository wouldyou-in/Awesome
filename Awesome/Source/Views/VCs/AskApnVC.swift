//
//  AskApnVC.swift
//  Awesome
//
//  Created by 박익범 on 2021/08/05.
//

import UIKit

class AskApnVC: UIViewController {

//MARK: IBOutlet
    @IBOutlet weak var accessButton: UIButton!
    @IBOutlet weak var laterButton: UIButton!
    @IBOutlet weak var backGroundView: UIView!
    let appdelegate = UIApplication.shared.delegate as! AppDelegate

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()

    }
    func setLayout(){
        appdelegate.shouldSupportAllOrientation = false
        accessButton.backgroundColor = UIColor.mainPink
        accessButton.clipsToBounds = true
        accessButton.layer.cornerRadius = 25
        accessButton.titleLabel?.font = UIFont.gmarketSansBoldFont(ofSize: 18)
        laterButton.backgroundColor = UIColor.mainGray
        laterButton.clipsToBounds = true
        laterButton.layer.cornerRadius = 25
        laterButton.titleLabel?.font = UIFont.gmarketSansMediumFont(ofSize: 18)
        self.view.backgroundColor = .none
        backGroundView.clipsToBounds = true
        backGroundView.layer.cornerRadius = 15
    }
    
    func postDeviceToken(){
        PostDevieceTokenDataService.shared.AutoLoginService(push_token: UserDefaults.standard.string(forKey: "deviceToken") ?? "none" ) { [self] result in
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
//MARK: IBAction
    @IBAction func accessButtonClicked(_ sender: Any) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge], completionHandler: {didAllow,Error in
                UserDefaults.standard.setValue(didAllow, forKey: "noti")
            })
        UNUserNotificationCenter.current().delegate = self
        self.dismiss(animated: true, completion: nil)
        postDeviceToken()
    }
    @IBAction func laterButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    


}
extension AskApnVC: UNUserNotificationCenterDelegate{
    
}
