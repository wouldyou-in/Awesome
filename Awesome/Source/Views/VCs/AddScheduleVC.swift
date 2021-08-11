//
//  AddScheduleVC.swift
//  Awesome
//
//  Created by 박익범 on 2021/07/31.
//

import UIKit

class AddScheduleVC: UIViewController {
//MARK: IBOulet
    @IBOutlet weak var nameButton: UIButton!
    @IBOutlet weak var startTimeButton: UIButton!
    @IBOutlet weak var finishTimeButton: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var backGroundView2: UIView!
    //MARK: Var
    var selectDay: String = ""
    var nameText : String = "이름"
    var startTime : String = "시작시간"
    var finishTime : String = "종료시간"
    var delegate: refreshDelegate?

    var startHour: Int = 0
    var finishHour: Int = 0
    let appdelegate = UIApplication.shared.delegate as! AppDelegate

//MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()

    }
//MARK: func
    func setLayout(){
        appdelegate.shouldSupportAllOrientation = false
        nameButton.clipsToBounds = true
        nameButton.layer.cornerRadius = 20
        startTimeButton.clipsToBounds = true
        startTimeButton.layer.cornerRadius = 20
        finishTimeButton.clipsToBounds = true
        finishTimeButton.layer.cornerRadius = 20
        backgroundView.clipsToBounds = true
        backgroundView.layer.cornerRadius = 20
        backGroundView2.backgroundColor = .none
        okButton.clipsToBounds = true
        okButton.layer.cornerRadius = 20
        self.view.backgroundColor = .clear
    }
    func setIsAccess(){
        PostAccessDenineDataService.shared.AutoLoginService(calendar_id: UserDefaults.standard.integer(forKey: "postID"), is_accept: true) { [self] result in
            switch result{
            case .success(let tokenData):
                print("수락 혹은 거절 성공")
                delegate?.refreshDelegate()
            case .requestErr(let msg):
                print("requestErr")
            default :
                print("ERROR")
            }
        }
    }
//MARK: IBAction
    @IBAction func nameButtonClicked(_ sender: Any) {
        let nameAlert = UIAlertController(title: "이름을 입력하세요", message: "", preferredStyle: UIAlertController.Style.alert)
        nameAlert.addTextField()
        let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
            self.nameText = nameAlert.textFields?[0].text ?? ""
            self.nameButton.setTitle(self.nameText, for: .normal)
           
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .default)
        {(action) in}
        nameAlert.addAction(okAction)
        nameAlert.addAction(cancelAction)
        present(nameAlert, animated: true, completion: nil)
    }
    
    
    
  
    @IBAction func okButtonClicked(_ sender: Any) {
//
//
//        let calendar = Calendar.current
//        var formatter = DateFormatter()
//        formatter.dateFormat = "yyyy/MM/dd"
//        let startDate = formatter.date(from: startTime)
//        let endDate = formatter.date(from: endTime)
//        if startTime.contains("시작기간") || endTime.contains("종료기간") {
//            self.makeAlert(title: "오류", message: "기간을 입력하지 않았습니다. 시작기관과 종료기간을 정확히 입력해주세요")
//        }
//        else {
//        let judgeMentTime = Int(startDate!.timeIntervalSince(endDate!))
//        if judgeMentTime > 0 {
//            self.makeAlert(title: "오류", message: "기간이 잘못 입력되었습니다. 다시입력해주세요")
//        }
//        else{
//            setDateData()
//            self.dismiss(animated: true, completion: nil)
//        }
//        }
//
//
        
        
        if startTime.contains("시작시간") || finishTime.contains("종료시간") || nameText.contains("이름") {
            self.makeAlert(title: "오류", message: "시간을 입력하지 않았습니다. 시작시간과 종료시간을 정확히 입력해주세요")

        }
        else {
        let start = startTime.components(separatedBy: ":")
        let finish = finishTime.components(separatedBy: ":")
        
        if Int(start[0])! > 15{
            startHour = Int(start[0])! - 15
            finishHour = Int(finish[0])! - 15
        }
        else{
            startHour = 15 - Int(start[0])!
            finishHour = 15 - Int(finish[0])!
        }
        print(startHour, start[1])
        
        let startString:String = "\(selectDay)T\(startTime):00+09:00"
        let finishString:String = "\(selectDay)T\(finishTime):00+09:00"
        
        print(startString, finishString)
            var formatter = ISO8601DateFormatter()
            let startDate = formatter.date(from: startString)
            let endDate = formatter.date(from: finishString)
            print(startDate, endDate)
            let judgeMentTime = Int(startDate!.timeIntervalSince(endDate!))
            
            
            if judgeMentTime > 0{
                self.makeAlert(title: "오류", message: "시간이 잘못 입력되었습니다. 다시입력해주세요")
            }
            else {
            
        PostScheduleDataService.shared.postScheduleService(comment: nameText, start_date: startString, end_date: finishString, receiver_id: UserDefaults.standard.integer(forKey: "myKey") ) { [self] result in
            switch result{
            case .success(let tokenData):
                print("성공")
                self.setIsAccess()
            case .requestErr(let msg):
                print("requestErr")
            default :
                print("ERROR")
            }
        }
        self.dismiss(animated: true, completion: nil)
        }
        }
    }
    
}
extension AddScheduleVC: dateData{
    @IBAction func startTimeButtonClicked(_ sender: Any) {
        guard let datePickerVC = UIStoryboard(name: "DatePicker", bundle: nil).instantiateViewController(identifier: "DatePickerVC") as? DatePickerVC else {return}
        datePickerVC.startDelegate = self
        self.present(datePickerVC, animated: true, completion: nil)
        print(startTime)
    }
    
    @IBAction func finishTimeButtonClicked(_ sender: Any) {
        guard let datePickerVC = UIStoryboard(name: "DatePicker", bundle: nil).instantiateViewController(identifier: "DatePickerVC") as? DatePickerVC else {return}
        datePickerVC.endDelegate = self
        self.present(datePickerVC, animated: true, completion: nil)
    }
    
    func startDataSend(data: String) {
        startTimeButton.setTitle(data, for: .normal)
        startTime = data
    }
    
    func finishDateSend(data: String) {
        finishTimeButton.setTitle(data, for: .normal)
        finishTime = data
    }
}

