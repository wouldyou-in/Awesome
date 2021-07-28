//
//  SettingVC.swift
//  Awesome
//
//  Created by 박익범 on 2021/07/28.
//

import UIKit

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
    
//MARK: Var
    var leftInviteCountText: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setHeaderView()
        setButtonView()

    }
//MARK: Function
    func setHeaderView(){
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
//MARK: IBAction
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func inviteButtonClicked(_ sender: Any) {
    }
    @IBAction func linkShareButtonClicked(_ sender: Any) {
    }
    @IBAction func logoutButtonClicked(_ sender: Any) {
    }
    @IBAction func withdrawButtonClicked(_ sender: Any) {
    }
    

}
