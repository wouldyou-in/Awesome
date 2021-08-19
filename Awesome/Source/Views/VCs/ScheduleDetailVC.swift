//
//  ScheduleDetailVC.swift
//  Awesome
//
//  Created by 박익범 on 2021/08/02.
//

import UIKit

protocol tableViewReloadDelegate {
    func tableViewReloadDelegate()
}

class ScheduleDetailVC: UIViewController {
//MARK: IBOulet
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var promiseObject: UILabel!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var subjectView: UIView!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var denineButton: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var headerLabelConstraint: NSLayoutConstraint!
    
//MARK: Var
    let width = UIScreen.main.bounds.width
    var scID: Int = 0
    var delegate: tableViewReloadDelegate?
    let appdelegate = UIApplication.shared.delegate as! AppDelegate

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabelFont()
        setRadius()
        setDetailLabel()

    }
//MARK: Function
    func setLabelFont(){
        appdelegate.shouldSupportAllOrientation = false
        if UIScreen.main.bounds.width > 500{
            headerLabelConstraint.constant = headerLabelConstraint.constant * (width/500)

        }
        else{
        headerLabelConstraint.constant = headerLabelConstraint.constant * (width/428)
        }
    }
    func setData(time: String , information: String, person: String, scheduleID: Int){
        nameLabel.text = person
        timeLabel.text = time
        promiseObject.text = information
        scID = scheduleID
    }
    func setDetailLabel(){
        promiseObject.lineBreakStrategy = .hangulWordPriority
        promiseObject.numberOfLines = 5
    }
    func setRadius(){
        backgroundView.clipsToBounds = true
        backgroundView.layer.cornerRadius = 12
        nameView.clipsToBounds = true
        nameView.layer.cornerRadius = 12
        timeView.clipsToBounds = true
        timeView.layer.cornerRadius = 12
        subjectView.clipsToBounds = true
        subjectView.layer.cornerRadius = 12
        acceptButton.clipsToBounds = true
        acceptButton.layer.cornerRadius = 20
        denineButton.clipsToBounds = true
        denineButton.layer.cornerRadius = 20
        self.view.backgroundColor = .none
    }
//MARK: IBAction
    @IBAction func acceptButtonClicked(_ sender: Any) {
        postAccessDenine(bool: true)
        delegate?.tableViewReloadDelegate()
        self.dismiss(animated: true, completion: nil)
        
    }
    @IBAction func denineButtonClicked(_ sender: Any) {
        self.makeRequestAlert(title: "약속거적", message: "정말 약속을 거절하시겠습니까?",
                              okAction: {_ in self.postAccessDenine(bool: false)
                                self.delegate?.tableViewReloadDelegate()
                                self.dismiss(animated: true, completion: nil)
                              }, cancelAction: nil, completion: nil)
    }
    @IBAction func tapButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    //MARK: function
    func postAccessDenine(bool: Bool){
        PostAccessDenineDataService.shared.AutoLoginService(calendar_id: scID, is_accept: bool) { [self] result in
            switch result{
            case .success(let tokenData):
                print("수락 혹은 거절 성공")
            case .requestErr(let msg):
                print("requestErr")
            default :
                print("ERROR")
            }
        }
    }
    
}

