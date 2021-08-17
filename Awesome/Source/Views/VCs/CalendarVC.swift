//
//  CalendarVC.swift
//  Awesome
//
//  Created by 박익범 on 2021/07/30.
//

import UIKit
import FSCalendar
import EventKit

protocol refreshDelegate {
    func refreshDelegate(isDelete: Bool)
}

class CalendarVC: UIViewController {
//MARK: IBOulet
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet weak var plusScheduleButton: UIButton!
    @IBOutlet weak var notScheduleButton: UIButton!
    @IBOutlet weak var ScheduleButton: UIButton!
    @IBOutlet weak var calendarConstarint: NSLayoutConstraint!
    
    
//MARK: Var
    
    lazy var scheduleButtons: [UIButton] = [self.plusScheduleButton, self.notScheduleButton]
    var isShowFloating: Bool = false
    var isSchedule: Bool = false

    var Userevents : [Date] = []
    var blockDateString: [String] = []
    var blockDate: [Date] = []
    
    let eventStore = EKEventStore()
    
    var yearData : String = ""
    var monthData : String = ""
    var dayData : String = ""
    var checkDate : String = ""
    var isScheduleFinish: Bool = false
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    var beforeCheckDate: String = ""
    
    var userEventsDetail: [CalendarDataModel] = []
    var scheduleData: [eventCalendarModel] = []
    var blockDataDetail: [BlockDataModel] = []
    var detailCalendar: [detailCalendarModel] = []
    
//MARK: viewDidLoad
    override func viewDidDisappear(_ animated: Bool) {
        print("viewdiddisapper")
    }
    override func viewWillAppear(_ animated: Bool) {
        print("viewwillapper")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.sendSubviewToBack(tableView)
        self.view.sendSubviewToBack(calendarView)
        setiPadUI()
        setCell()
        setCalendar()
        setHeaderView()
        requestAccess()
        setUserEvents()
        setdate()
        setCalendarData()
        getBlockDateData()
        appdelegate.shouldSupportAllOrientation = false
    }
//MARK: Function
    func setiPadUI(){
        print(calendarView.fs_width,UIScreen.main.bounds.width)
        if UIScreen.main.bounds.width > 500{
            print(calendarConstarint.constant)
            calendarConstarint.constant = 200
        }
    }
    func setCalendarData(){
        GetCalendarDataService.CalendarData.getRecommendInfo{ (response) in
            switch(response)
            {
            case .success(let loginData):
                if let response = loginData as? CalendarDataModel{
                    DispatchQueue.global().sync {
                        self.userEventsDetail.append(response)
                        print("어펜드 끝")
                    }
                    if response.myCalendar.count != 0{
                        self.serverData()
                        self.calendarView.reloadData()
                    }
                    self.calendarView.reloadData()
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
    
    func getBlockDateData(){
        GetBlockScheduleService.blockData.getRecommendInfo{ (response) in
            switch(response)
            {
            case .success(let loginData):
                if let response = loginData as? BlockDataModel{
                    self.blockDataDetail.append(response)
                    print("어펜드 끝")
                }
                self.calendarView.reloadData()
                self.setBlockData()
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
    
    func serverData(){
        let UpdateFormatter = DateFormatter()
        UpdateFormatter.locale = Locale(identifier: "ko_KR")
        UpdateFormatter.dateFormat = "yyyy-MM-dd"
        
        if userEventsDetail[0].myCalendar.count == 0{
            print("없음 ㅠ")
        }
        else{
        
        for i in 0 ... userEventsDetail[0].myCalendar.count - 1{
            if userEventsDetail[0].myCalendar[i].isAccept ?? false == true{
                print("서버 데이터")
                let dateData = UpdateFormatter.string(from: userEventsDetail[0].myCalendar[i].startDate)
                let realData = UpdateFormatter.date(from: dateData)
                Userevents.append(realData!)
            }
        }
            setdate()

        }
    }
    func setBlockData(){
        let calendar = Calendar.current
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        var blockCount: Int = blockDataDetail[0].block.count
        var forBlockCount: Int = blockCount
        
        if blockCount != 0{
            for i in 0 ... blockCount-1{
                let startBlockdate = blockDataDetail[0].block[i].startDate.components(separatedBy: "T")
                let endBlockdate = blockDataDetail[0].block[i].endDate.components(separatedBy: "T")
                
                var start = formatter.date(from: startBlockdate[0])
                let end = formatter.date(from: endBlockdate[0])
                
                let interval = end!.timeIntervalSince(start!)
                let days = Int(interval / 86400)
                
                blockDate.append(start ?? Date())
                blockDate.append(end ?? Date())
                
                if days == 0{
                    print("하루임 ㅋ")
                }
                else{
                for k in 0 ... days-1{
                    var dateComponent = DateComponents(day: 1)
                    var plusDay = calendar.date(byAdding: dateComponent, to: start!)
                    start = plusDay
                blockDate.append(plusDay!)
                }
                }
            }
        }
        else{
            print("블락 데이터가 없습니다.")
        }
        
        
    }
    
    func setCalendar(){
        let formatter = DateFormatter()
        appdelegate.shouldSupportAllOrientation = false
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        calendarView.dataSource = self
        calendarView.delegate = self
        calendarView.backgroundColor = .white
        calendarView.collectionView.backgroundColor = UIColor.white
        calendarView.calendarHeaderView.backgroundColor = UIColor.mainGray
        calendarView.appearance.headerMinimumDissolvedAlpha = 0.0
        calendarView.headerHeight = 0.0
        calendarView.weekdayHeight = 70
        calendarView.appearance.weekdayTextColor = UIColor.black
        calendarView.appearance.selectionColor = UIColor.mainPink
        calendarView.appearance.todayColor = UIColor.mainPinkAlpha
        calendarView.appearance.eventDefaultColor = UIColor.mainPinkAlpha
        calendarView.appearance.eventSelectionColor = UIColor.mainPink
        calendarView.appearance.weekdayFont = UIFont.gmarketSansMediumFont(ofSize: 14)
        calendarView.calendarWeekdayView.backgroundColor = UIColor.mainGray
        calendarView.calendarWeekdayView.weekdayLabels[0].text = "Su"
        calendarView.calendarWeekdayView.weekdayLabels[1].text = "Mo"
        calendarView.calendarWeekdayView.weekdayLabels[2].text = "Tu"
        calendarView.calendarWeekdayView.weekdayLabels[3].text = "We"
        calendarView.calendarWeekdayView.weekdayLabels[4].text = "Th"
        calendarView.calendarWeekdayView.weekdayLabels[5].text = "Fr"
        calendarView.calendarWeekdayView.weekdayLabels[6].text = "Sa"
        calendarView.firstWeekday = 1
        calendarView.appearance.titleFont = UIFont.gmarketSansMediumFont(ofSize: 13)
        formatter.dateFormat = "yyyy-MM-dd"
        checkDate = formatter.string(from: Date())
        print("adsf", checkDate)
        setdate()
    }
    func setCell(){
        tableView.registerCustomXib(xibName: "myScheduleTVC")
        tableView.registerCustomXib(xibName: "NoScheduleTVC")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    
    func setHeaderView(){
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MM"
        let yearFormatter = DateFormatter()
        yearFormatter.dateFormat = "YYYY"
        let date = Date()
        headerView.backgroundColor = UIColor.mainGray
        yearLabel.font = UIFont.gmarketSansMediumFont(ofSize: 14)
        monthLabel.font = UIFont.gmarketSansBoldFont(ofSize: 30)
        tableView.backgroundColor = UIColor.white
        monthLabel.text = monthFormatter.string(from: date)
        yearLabel.text = yearFormatter.string(from: date)
    }
//MARK: getUserData
    func requestAccess() {
            eventStore.requestAccess(to: .event) { (granted, error) in
                if granted {
                    DispatchQueue.main.async {
                        self.eventStore.reset()
                        self.setUserEvents()
                        self.setdate()
                        self.calendarView.reloadData()
                    }
                }
            }
    }
    func setUserEvents(){
        let nowdate = Date()
        let enddate = Calendar.current.date(byAdding: .day, value: 30, to: nowdate)
        let startDate = Calendar.current.date(byAdding: .day, value: -30, to: nowdate)
        let weekFromNow = Date().advanced(by: 30.0)
        let predicate = eventStore.predicateForEvents(withStart: startDate!, end: enddate!, calendars: nil)
            let events = eventStore.events(matching: predicate)
            let UpdateFormatter = DateFormatter()
            UpdateFormatter.locale = Locale(identifier: "ko_KR")
            UpdateFormatter.dateFormat = "yyyy-MM-dd"
            for event in events {
                let dateData = UpdateFormatter.string(from: event.startDate!)
                let realData = UpdateFormatter.date(from: dateData)
                Userevents.append(realData!)
            }
    }
    
    func days(from date: Date) -> Int {
        let calendar = Calendar.current
        let currentDate = Date()
        
        return calendar.dateComponents([.second], from: date, to: currentDate).second! + 1
    }

//MARK: dataConnection
    func setdate(){
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-mm-DD"
//        let convertDate = dateFormatter.date(from: checkDate)
        let checkDateConvert = checkDate
        beforeCheckDate = checkDate
        let nowdate = Date()
        let enddate = Calendar.current.date(byAdding: .day, value: 30, to: nowdate)
        let startDate = Calendar.current.date(byAdding: .day, value: -30, to: nowdate)
        let weekFromNow = Date().advanced(by: 30.0)
              let predicate = eventStore.predicateForEvents(withStart: startDate!, end: enddate!, calendars: nil)
            scheduleData = []
        detailCalendar = []
              let events = eventStore.events(matching: predicate)
              let formatter = DateFormatter()
        let detailFormatter = DateFormatter()
              let startTimeFormatter = DateFormatter()
              let finishTimeFormatter = DateFormatter()
              formatter.locale = Locale(identifier: "ko_KR")
              formatter.dateFormat = "yyyy-MM-dd"
        detailFormatter.locale = Locale(identifier: "ko_KR")
        detailFormatter.dateFormat = "MM월 d일"
        var ckDate = detailFormatter.date(from: checkDate ?? "")
        var ckDateMD = detailFormatter.string(from: ckDate ?? Date())
              startTimeFormatter.dateFormat = "HH:mm"
              finishTimeFormatter.dateFormat = "HH:mm"
              let comma : String = " ~ "
            
        for event in events {
                  let start = formatter.string(from: event.startDate)
                  let startTime = startTimeFormatter.string(from: event.startDate)
                  let finishTime = finishTimeFormatter.string(from: event.endDate)
            if checkDate == start{
//                print(days(from: event.endDate),"이게맞냐?")
                if days(from: event.endDate) > 0 {
                    isScheduleFinish = true
                }
                else{
                    isScheduleFinish = false
                }
                scheduleData.append(contentsOf:[eventCalendarModel(name: event.title, time: startTime + comma + finishTime, icon: "continueIcon", isFinish: isScheduleFinish)])
                detailCalendar.append(contentsOf: [detailCalendarModel(maker: event.organizer?.name ?? "없음" , time: ckDateMD + startTime + comma + finishTime, detail: event.title, id: 0, participant: 0)])
                Userevents.append(event.startDate)
                tableView.reloadData()
                  }
            if scheduleData.count != 0{
            isSchedule = true
            }
            else{
            isSchedule = false
                tableView.reloadData()
            }
          }
        if userEventsDetail.count != 0{
        for userEvents in userEventsDetail[0].myCalendar{
            checkDate = beforeCheckDate
            if userEvents.isAccept == true {
            let start = formatter.string(from: userEvents.startDate)
            let startTime = startTimeFormatter.string(from: userEvents.startDate)
            let finishTime = finishTimeFormatter.string(from: userEvents.endDate)
            if checkDate == start{
                if days(from: userEvents.endDate) < 0 {
                    isScheduleFinish = false
                }
                else{
                    isScheduleFinish = true
                }
                
                scheduleData.append(contentsOf:[eventCalendarModel(name: userEvents.creatorName, time: startTime + comma + finishTime, icon: "continueIcon", isFinish: isScheduleFinish)])
                detailCalendar.append(contentsOf: [detailCalendarModel(maker: userEvents.creatorName , time: ckDateMD + " " + startTime + comma + finishTime, detail: userEvents.comment, id: userEvents.id, participant: userEvents.participant)])
//                  Userevents.append(userEvents.startDate)
//                print("asdfasfasfasfdasfsdfasfsfdfadfa")
                tableView.reloadData()
            }
            if scheduleData.count != 0{
            isSchedule = true
                self.tableView.reloadData()
            }
            else{
            isSchedule = false
                tableView.reloadData()
            }
            
        }
        }
        }
        
        
    }
    
//MARK: IBAction
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func scheduleButtonClicked(_ sender: Any) {
            if isShowFloating == false {
            scheduleButtons.forEach { [weak self] button in
                button.isHidden = false
                button.alpha = 0
                UIView.animate(withDuration: 0.3) {
                    if let image = UIImage(named: "closeButton") {
                        self!.ScheduleButton.setImage(image, for: .normal)
                    }
                    button.alpha = 1
                    self?.view.layoutIfNeeded()
                }
            }
                isShowFloating = true
            }
            else{
            scheduleButtons.reversed().forEach { button in
                UIView.animate(withDuration: 0.3) {
                    if let image = UIImage(named: "schesuleButton") {
                        self.ScheduleButton.setImage(image, for: .normal)
                    }
                    button.isHidden = true
                    self.view.layoutIfNeeded()
                }
            }
                isShowFloating = false
            }

        }
    @IBAction func plusScheduleButtonClicked(_ sender: Any) {
        guard let plusVC = UIStoryboard(name: "AddSchedule", bundle: nil).instantiateViewController(identifier: "AddScheduleVC") as? AddScheduleVC else {return}
        self.present(plusVC, animated: true, completion: nil)
        plusVC.delegate = self
        plusVC.selectDay = checkDate
        beforeCheckDate = checkDate
    }
    
    @IBAction func notScheduleButtonClicked(_ sender: Any) {
        guard let blockVC = UIStoryboard(name: "BlockSchedule", bundle: nil).instantiateViewController(identifier: "BlockScheduleVC") as? BlockScheduleVC else {return}
        blockVC.delegate = self
        self.present(blockVC, animated: true, completion: nil)
    }
    
}
//MARK: Extension

extension CalendarVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isSchedule == false{
            self.makeAlert(title: "약속없음", message: "해당날에 약속이 없어요")
        }
        else{
        guard let detailVC = UIStoryboard(name: "DetailCalendar", bundle: nil).instantiateViewController(identifier: "DetailCalendarVC") as? DetailCalendarVC else {return}
        self.present(detailVC, animated: true, completion: nil)
            detailVC.setData(name: detailCalendar[indexPath.row].maker, time: detailCalendar[indexPath.row].time, detail: detailCalendar[indexPath.row].detail, id: detailCalendar[indexPath.row].id, participant: detailCalendar[indexPath.row].participant)
            detailVC.delegate = self
            tableView.reloadData()
        }

    }
}
extension CalendarVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSchedule == true{
//            print(isSchedule,"daf")
                  return scheduleData.count
              }
        else{
//            print(isSchedule,"daf")
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let scheduleCell: myScheduleTVC = tableView.dequeueReusableCell(withIdentifier: myScheduleTVC.identifier) as! myScheduleTVC
        let noScheduleCell: NoScheduleTVC = tableView.dequeueReusableCell(withIdentifier: NoScheduleTVC.identifier) as! NoScheduleTVC
        
        
        
        if isSchedule == true{
            print("셀실행")
            print(scheduleData[indexPath.row].time)
            scheduleCell.setData(name: scheduleData[indexPath.row].name, time: scheduleData[indexPath.row].time, isFinish: scheduleData[indexPath.row].isFinish)
        
            return scheduleCell
        }
        if isSchedule == false{
            print("없는셀 실행")
            return noScheduleCell
        }
        return UITableViewCell()
    }
    
    
    
}

extension CalendarVC: FSCalendarDelegate{
    
    public func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        tableView.reloadData()
//        let selectFormatter = DateFormatter()
//        selectFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        
        let yearFormatter = DateFormatter()
            yearFormatter.dateFormat = "YYYY"
            yearData = yearFormatter.string(from: date)
            
        let monthFormatter = DateFormatter()
            monthFormatter.dateFormat = "MM"
            monthData = monthFormatter.string(from: date)
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "dd"
        dayData = dayFormatter.string(from: date)
        
        checkDate = yearData+"-"+monthData+"-"+dayData
        setdate()
          }
    
}
extension CalendarVC: FSCalendarDataSource{
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let monthFormatter = DateFormatter()
        let yearFormatter = DateFormatter()
        yearFormatter.dateFormat = "YYYY"
        monthFormatter.dateFormat = "MM"
        var month = monthFormatter.string(from: calendarView.currentPage)
        var year = yearFormatter.string(from: calendarView.currentPage)
        monthLabel.text = String(month)
        yearLabel.text = String(year)
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        if Userevents.contains(date){
            return 1
        }
        else{
            return 0
        }
    }
}
extension CalendarVC: FSCalendarDelegateAppearance{
//
//    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "d"
//        var dateStr = formatter.string(from: date)
//        if blockDate.contains(date){
//            return dateStr
//        }
//        else{
//            return dateStr
//        }
//    }

    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        if blockDate.contains(date){
        return UIColor.gray
        }
        else{
            return .black
        }
    }
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        if blockDate.contains(date){
            return "😴"
        }
        else{
            return .none
        }
    }
//    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
//        if blockDate.contains(date){
//            return UIImage(named: "line")
//        }
//        else{
//            return .none
//        }
//    }
//    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, imageOffsetFor date: Date) -> CGPoint {
//        print(calendarView.collectionView.fs_height)
//        return CGPoint(x:20, y: 20)
//    }
}
    
extension CalendarVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension CalendarVC: refreshDelegate{
    func refreshDelegate(isDelete: Bool) {
        if isDelete == true{
            Userevents = []
            userEventsDetail = []
            blockDate = []
            blockDateString = []
            blockDataDetail = []
            setCalendarData()
            setUserEvents()
            getBlockDateData()
            isSchedule = false
            tableView.reloadData()
        }
        else{
            Userevents = []
            userEventsDetail = []
            blockDate = []
            blockDateString = []
            blockDataDetail = []
            setCalendarData()
            setUserEvents()
            getBlockDateData()
            tableView.reloadData()
        }
    }
}
