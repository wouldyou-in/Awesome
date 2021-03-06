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
    var delegate: refreshDelegate?
    var blockDataDetail: [BlockDataModel] = []
    var blockDate: [String] = []
    
    var startDate: String = ""
    var endDate: String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        judgeBlockTime()
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
        
        let startYear = startSplitDate[0]
        var startMonth = startSplitDate[1]
//        if Int(startMonth)! < 10 {
//            startMonth = "0\(startMonth)"
//        }
        var startMonthDay = startSplitDate[2]
//        if Int(startMonthDay)! < 10{
//            startMonthDay = "0\(startMonthDay)"
//        }
        
        let endYear = endSplitDate[0]
        var endMonth = endSplitDate[1]
//        if Int(endMonth)! < 10 {
//            endMonth = "0\(endMonth)"
//        }
        var endMonthDay = endSplitDate[2]
//        if Int(endMonthDay)! < 10{
//            endMonthDay = "0\(endMonthDay)"
//        }
        
        let startDate: String = "\(startYear)-\(startMonth)-\(startMonthDay) 00:00:00"
        let endDate: String = "\(endYear)-\(endMonth)-\(endMonthDay) 23:59:59"
        
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
    
    func judgeBlockTime(){
        GetBlockScheduleService.blockData.getRecommendInfo{ (response) in
            switch(response)
            {
            case .success(let loginData):
                if let response = loginData as? BlockDataModel{
                    self.blockDataDetail.append(response)
                    print("어펜드 끝")
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
    func getBlockTime(){
        if blockDataDetail[0].block.count == 0 {
            print("blockdata is nil")
        }
        else{
        for i in blockDataDetail[0].block{
            var start = i.startDate.components(separatedBy: "T")
            var end = i.endDate.components(separatedBy: "T")
            var stDate = start[0].components(separatedBy: "-")
            var edDate = start[0].components(separatedBy: "-")
            var startDate = stDate[0] + "/" + stDate[1] + "/" + stDate[2]
            var endDate = edDate[0] + "/" + edDate[1] + "/" + edDate[2]
            blockDate.append(startDate)
            blockDate.append(endDate)
            print(startDate, endDate)
        }
        }
    }
//MARK: IBAction
    
    @IBAction func startTimeButtonClicked(_ sender: Any) {
        getBlockTime()
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
        let calendar = Calendar.current
        var formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let startDate = formatter.date(from: startTime)
        let endDate = formatter.date(from: endTime)
        if startTime.contains("시작기간") || endTime.contains("종료기간") {
            self.makeAlert(title: "오류", message: "기간을 입력하지 않았습니다. 시작기간과 종료기간을 정확히 입력해주세요")
        }
        else {
        let judgeMentTime = Int(startDate!.timeIntervalSince(endDate!))
        if judgeMentTime > 0 {
            self.makeAlert(title: "오류", message: "기간이 잘못 입력되었습니다. 다시입력해주세요")
        }
        else{
            print("dfadf", blockDate)
            if blockDate.contains(startTime) || blockDate.contains(endTime){
                self.makeAlert(title: "오류", message: "받지 않는 기간중 겹치는 기간이 있습니다.")
            }
            else {
                setDateData()
                delegate?.refreshDelegate(isDelete: false)
                self.dismiss(animated: true, completion: nil)
            }
        }
        }
       
    }
    @IBAction func tapButtonClicked(_ sender: Any) {
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
