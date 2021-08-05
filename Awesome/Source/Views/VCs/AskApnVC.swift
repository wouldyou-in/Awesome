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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()

    }
    func setLayout(){
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
//MARK: IBAction
    @IBAction func accessButtonClicked(_ sender: Any) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge], completionHandler: {didAllow,Error in
                UserDefaults.standard.setValue(didAllow, forKey: "noti")
            })
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func laterButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    


}
