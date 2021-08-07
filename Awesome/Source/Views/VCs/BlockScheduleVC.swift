//
//  BlockScheduleVC.swift
//  Awesome
//
//  Created by 박익범 on 2021/08/05.
//

import UIKit

class BlockScheduleVC: UIViewController {

//MARK: IBOutlet
    @IBOutlet weak var startTimeButton: UIButton!
    @IBOutlet weak var endTimeButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var backGroundView: UIView!

//MARK: Var
    var startTime: String = "시작기간"
    var endTime: String = "종료기간"
    let appdelegate = UIApplication.shared.delegate as! AppDelegate

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }
//MARK: func
    func setLayout(){
        appdelegate.shouldSupportAllOrientation = false
        startTimeButton.clipsToBounds = true
        startTimeButton.layer.cornerRadius = 15
        endTimeButton.clipsToBounds = true
        endTimeButton.layer.cornerRadius = 15
        backGroundView.clipsToBounds = true
        backGroundView.layer.cornerRadius = 15
        okButton.clipsToBounds = true
        okButton.layer.cornerRadius = 15
        self.view.backgroundColor = .none
    }
    func setDateData(){
        
        let startSplitDate = startTime.components(separatedBy: "/")
        let endSplitDate = endTime.components(separatedBy: "/")
        
        let startYear = startSplitDate[2]
        var startMonth = startSplitDate[0]
        if Int(startMonth)! < 10 {
            startMonth = "0\(startMonth)"
        }
        var startMonthDay = startSplitDate[1]
        if Int(startMonthDay)! < 10{
            startMonthDay = "0\(startMonthDay)"
        }
        
        let endYear = endSplitDate[2]
        var endMonth = endSplitDate[0]
        if Int(endMonth)! < 10 {
            endMonth = "0\(endMonth)"
        }
        var endMonthDay = endSplitDate[1]
        if Int(endMonthDay)! < 10{
            endMonthDay = "0\(endMonthDay)"
        }
        
        let startDate: String = "20\(startYear)-\(startMonth)-\(startMonthDay) 00:00:00"
        let endDate: String = "20\(endYear)-\(endMonth)-\(endMonthDay) 23:59:59"
        
        print(startDate, endDate)
        PostBlockDataService.shared.postScheduleService(start_date: startDate, end_date: endDate) { [self] result in
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
    
    @IBAction func startTimeButtonClicked(_ sender: Any) {
        guard let startVC = UIStoryboard(name: "TermPicker", bundle: nil).instantiateViewController(identifier: "TermPickerVC") as? TermPickerVC else {return}
        self.present(startVC, animated: true, completion: nil)
        startVC.startDelegate = self
    }
    @IBAction func endTimeButtonClicked(_ sender: Any) {
        guard let endVC = UIStoryboard(name: "TermPicker", bundle: nil).instantiateViewController(identifier: "TermPickerVC") as? TermPickerVC else {return}
        self.present(endVC, animated: true, completion: nil)
        endVC.endDelegate = self
    }
    @IBAction func okButtonClicked(_ sender: Any) {
        setDateData()
        self.dismiss(animated: true, completion: nil)
    }
    
}
//MARK: Extension
extension BlockScheduleVC: dateData{
    func startDataSend(data: String) {
        startTimeButton.setTitle(data, for: .normal)
        startTime = data
        print(data)
    }
    
    func finishDateSend(data: String) {
        endTimeButton.setTitle(data, for: .normal)
        endTime = data
        print(data)
    }
    
    
}
