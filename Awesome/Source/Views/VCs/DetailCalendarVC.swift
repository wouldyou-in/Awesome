//
//  DetailCalendarVC.swift
//  Awesome
//
//  Created by 박익범 on 2021/08/12.
//

import UIKit

class DetailCalendarVC: UIViewController {
    
//MARK: IBOutlet
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var headerLabelConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameLabelView: UIView!
    @IBOutlet weak var timeLabelView: UIView!
    @IBOutlet weak var detailLabelView: UIView!
    @IBOutlet weak var deleteButton: UIButton!
    //MARK: Var
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    let width = UIScreen.main.bounds.width
    
    var scheduleID: Int = 0
    var participantNum: Int = 0
    var detailText: String = ""
    var userSc: Bool = false
    
    var delegate: refreshDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setLabelFont()
        setDetailLabel()
        // Do any additional setup after loading the view.
    }

    func setDetailLabel(){
        detailLabel.lineBreakStrategy = .hangulWordPriority
        detailLabel.numberOfLines = 5
    }
    func setData(name: String, time: String, detail: String, id: Int, participant: Int, userSchedule: Bool){
        print(name, time, detail)
        nameLabel.text = name
        timeLabel.text = time
        detailLabel.text = detail
        detailText = detail
        participantNum = participant
        scheduleID = id
        userSc = userSchedule
    }
    func setLayout(){
        nameLabelView.clipsToBounds = true
        nameLabelView.layer.cornerRadius = 12
        timeLabelView.clipsToBounds = true
        timeLabelView.layer.cornerRadius = 12
        detailLabelView.clipsToBounds = true
        detailLabelView.layer.cornerRadius = 12
        backgroundView.clipsToBounds = true
        backgroundView.layer.cornerRadius = 20
        okButton.clipsToBounds = true
        okButton.layer.cornerRadius = 20
        deleteButton.clipsToBounds = true
        deleteButton.layer.cornerRadius = 20
        self.view.backgroundColor = .clear

    }
    func setLabelFont(){
        appdelegate.shouldSupportAllOrientation = false
        if UIScreen.main.bounds.width > 500{
            headerLabelConstraint.constant = headerLabelConstraint.constant * (width/500)

        }
        else{
            headerLabelConstraint.constant = headerLabelConstraint.constant * (width/428)
        }
    }
    func deleteSchedule(){
        DeleteScheduleService.shared.DeleteService(id: scheduleID, comment: detailText, participant: participantNum) { [self] result in
                switch result{
                case .success(let tokenData):
                    print("삭제 성공")
                    delegate?.refreshDelegate(isDelete: true)
                case .requestErr(let msg):
                    print("requestErr")
                default :
                    print("ERROR")
                }
            }
    }
    
//MARK: IBAction
    @IBAction func okbuttonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func tapButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func deleteScheduleButtonClicked(_ sender: Any) {
        self.makeRequestAlert(title: "약속삭제", message: "정말 약속을 삭제하시겠습니까?",
                              okAction: {_ in
            if(self.userSc == false){
                self.makeAlert(title: "삭제불가", message: "삭제할 수 없는 약속입니다.", okAction: nil, completion: nil)
            }
            else{
                                self.deleteSchedule()
                                self.dismiss(animated: true, completion: nil)
            }
                              },
                              cancelAction: nil,
                              completion: nil)
    }
    

}
