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

    var startHour: Int = 0
    var finishHour: Int = 0
//MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()

    }
//MARK: func
    func setLayout(){
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
        self.view.backgroundColor = .none
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
//        let formatter = DateFormatter()
//        let hourFormatter = DateFormatter()
//        let minuteFormatter = DateFormatter()
//        formatter.locale = Locale(identifier: "ko_KR")
//        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
//        
//        var start = startTime.components(separatedBy: ":")
//        var finish = finishTime.components(separatedBy: ":")
//        
//        var startDate = formatter.date(from: selectDay)
//
//        if Int(start[0])! > 15{
//            startHour = Int(start[0])! - 15
//            finishHour = Int(finish[0])! - 15
//        }
//        else{
//            startHour = 15 - Int(start[0])!
//            finishHour = 15 - Int(finish[0])!
//        }
//        print(startHour, start[1])
//        
//        var addStartTime: Double = Double(startHour)*3600 + Double(start[1])! * 60
//        var addFinishTime: Double = Double(finishHour)*3600 + Double(finish[1])! * 60
//        
//        let startMydate = startDate?.addingTimeInterval(addStartTime)
//        let startString:String = "\(selectDay)T\(startTime):00+09:00"
//        let finishString:String = "\(selectDay)T\(finishTime):00+09:00"
//        let finishMydate = startDate?.addingTimeInterval(addFinishTime)
////        let startMyendDat =
////        var endDate = formatter.date(from: selectDay + finishTime)
//print(startString, finishString)
//        
//        PostScheduleDataService.shared.postScheduleService(comment: nameText, start_date: startString, end_date: finishString, receiver_id: UserDefaults.standard.integer(forKey: "myKey") ) { [self] result in
//            switch result{
//            case .success(let tokenData):
//                print("성공")
//            case .requestErr(let msg):
//                print("requestErr")
//            default :
//                print("ERROR")
//            }
//        }
//        
//        
//        self.dismiss(animated: true, completion: nil)
//        
//        
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