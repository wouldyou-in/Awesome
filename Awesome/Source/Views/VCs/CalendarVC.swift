//
//  CalendarVC.swift
//  Awesome
//
//  Created by 박익범 on 2021/07/30.
//

import UIKit
import FSCalendar
import EventKit

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
    
//MARK: Var
    
    lazy var scheduleButtons: [UIButton] = [self.plusScheduleButton, self.notScheduleButton]
    var isShowFloating: Bool = false
    var isSchedule: Bool = false

    var Userevents : [Date] = []
    
    let eventStore = EKEventStore()
    
    var yearData : String = ""
    var monthData : String = ""
    var dayData : String = ""
    var checkDate : String = ""
    
    var userEventsDetail: [CalendarDataModel] = []
    var scheduleData: [eventCalendarModel] = []
//MARK: viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.sendSubviewToBack(tableView)
        setCell()
        setCalendar()
        setHeaderView()
        requestAccess()
        setUserEvents()
        setdate()
        // Do any additional setup after loading the view.
    }
//MARK: Function
    func setCalendar(){
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
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        checkDate = formatter.string(from: Date())
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
                        // load events
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
//MARK: dataConnection
    func setdate(){
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-mm-DD"
//        let convertDate = dateFormatter.date(from: checkDate)
        let checkDateConvert = checkDate
        let nowdate = Date()
        let enddate = Calendar.current.date(byAdding: .day, value: 30, to: nowdate)
        let startDate = Calendar.current.date(byAdding: .day, value: -30, to: nowdate)
        let weekFromNow = Date().advanced(by: 30.0)
              let predicate = eventStore.predicateForEvents(withStart: startDate!, end: enddate!, calendars: nil)
            scheduleData = []
              let events = eventStore.events(matching: predicate)
              let formatter = DateFormatter()
              let startTimeFormatter = DateFormatter()
              let finishTimeFormatter = DateFormatter()
              formatter.locale = Locale(identifier: "ko_KR")
              formatter.dateFormat = "yyyy-MM-dd"
              startTimeFormatter.dateFormat = "HH:mm"
              finishTimeFormatter.dateFormat = "HH:mm"
              let comma : String = " ~ "
            
        for event in events {
                  let start = formatter.string(from: event.startDate)
                  let startTime = startTimeFormatter.string(from: event.startDate)
                  let finishTime = finishTimeFormatter.string(from: event.endDate)
            
            if checkDate == start{
                    scheduleData.append(contentsOf:[eventCalendarModel(name: event.title, time: startTime + comma + finishTime, icon: "continueIcon")])
                      Userevents.append(event.startDate)
//                  print("dd", scheduleData)
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
            let start = formatter.string(from: userEvents.startDate)
            let startTime = startTimeFormatter.string(from: userEvents.startDate)
            let finishTime = finishTimeFormatter.string(from: userEvents.endDate)
            if checkDate == start{
                scheduleData.append(contentsOf:[eventCalendarModel(name: userEvents.comment, time: startTime + comma + finishTime, icon: "continueIcon")])
//                  Userevents.append(userEvents.startDate)
              print("dd", scheduleData)
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
        plusVC.selectDay = checkDate
    }
    
    @IBAction func notScheduleButtonClicked(_ sender: Any) {
        guard let notVC = UIStoryboard(name: "NoSchedule", bundle: nil).instantiateViewController(identifier: "NoScheduleVC") as? NoScheduleVC else {return}
        self.present(notVC, animated: true, completion: nil)
    }
    
}
//MARK: Extension

extension CalendarVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
extension CalendarVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSchedule == true{
            print(isSchedule,"daf")
                  return scheduleData.count
              }
        else{
            print(isSchedule,"daf")
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let scheduleCell: myScheduleTVC = tableView.dequeueReusableCell(withIdentifier: myScheduleTVC.identifier) as! myScheduleTVC
        let noScheduleCell: NoScheduleTVC = tableView.dequeueReusableCell(withIdentifier: NoScheduleTVC.identifier) as! NoScheduleTVC
        
        if isSchedule == true{
            print("셀실행")
            scheduleCell.setData(name: scheduleData[indexPath.row].name, time: scheduleData[indexPath.row].time, isFinish: false)
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
        print(checkDate)
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
