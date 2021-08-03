//
//  HomeVC.swift
//  Awesome
//
//  Created by 박익범 on 2021/07/27.
//

import UIKit

class HomeVC: UIViewController {

//MARK: IBOutlet
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var hiAwesomeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var homeView: UIView!

    //MARK: VAR
    let attributedStr = NSMutableAttributedString(string: "어떰에 오신걸 환영합니다.")
    var profileName: String = ""
    var scheduleData: [ScheduleNoticeModel] = []
    var scheduleDateString: String = ""
    var titleSchedule: String = ""
    var finishSchedule: String = ""
    var timeAgo: String = ""

//MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        uppdateProfile()
        getScheduleData()
        setHeaderUI()
        setTableView()
        setIdentifier()
        initRefresh()
    }
    
//MARK: function
    func setIdentifier(){
        tableView.registerCustomXib(xibName: "HomeTVC")
    }
    
    
    func setHeaderUI(){
        homeView.backgroundColor = UIColor.mainGray
        headerView.backgroundColor = UIColor.mainGray
        nameLabel.font = UIFont.gmarketSansBoldFont(ofSize: fontReSize(size: 24))
        
        let stringLength = attributedStr.length
        attributedStr.addAttributes([.foregroundColor: UIColor.mainPink, .font: UIFont.gmarketSansBoldFont(ofSize: fontReSize(size: 18))], range: NSRange(location: 0, length: 2))
        attributedStr.addAttributes([.foregroundColor: UIColor.mainBlack, .font: UIFont.gmarketSansMediumFont(ofSize: fontReSize(size: 18))], range: NSRange(location: 2, length: stringLength-3))
        hiAwesomeLabel.attributedText = attributedStr
        
        nameLabel.text = "HI, \(profileName)"
        nameLabel.textColor = UIColor.black
        
        settingButton.layer.borderWidth = 1
        settingButton.layer.masksToBounds = true
        settingButton.layer.borderColor = UIColor.clear.cgColor
        settingButton.layer.cornerRadius = settingButton.frame.height/2
        
    }
    
    func uiReSize() {
        let screenWith = UIScreen.main.bounds.width
        let scale = screenWith/428
        let buttonWidth = settingButton.frame.width
        let buttonHeigth = settingButton.frame.width
        settingButton.frame.size = CGSize(width: buttonWidth * scale, height: buttonHeigth * scale)
    }
    
    func fontReSize(size: CGFloat) -> CGFloat{
        let screenWith = UIScreen.main.bounds.width
        let sizeFormatter = size/428
        let result = screenWith * sizeFormatter
        return result
    }
    
    func setTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.mainGray
    }
    func setProfile(){
        let defaults = UserDefaults.standard
        profileName = defaults.string(forKey: "name") ?? "none"
        nameLabel.text = "HI, \(profileName)"
        let url = URL(string: defaults.string(forKey: "profile")!)
            DispatchQueue.global().async { let data = try? Data(contentsOf: url!)
                DispatchQueue.main.async { self.settingButton.setImage(UIImage(data: data!), for: .normal)}}
    }
    
    func changeDate(start: Date, finish: Date, upload: String){
        let startFormatter = DateFormatter()
        let titleFormatter = DateFormatter()
        let finishFormatter = DateFormatter()
        let agoFormatter = DateFormatter()
        var nowDate = Date()
        
        startFormatter.locale = Locale(identifier: "ko_KR")
        startFormatter.dateFormat = "MM월 dd일 HH:mm"
        finishFormatter.locale = Locale(identifier: "ko_KR")
        finishFormatter.dateFormat = "HH:mm"
        titleFormatter.dateFormat = "yyyy년 MM월 dd일"
        agoFormatter.locale = Locale(identifier: "ko_KR")
        agoFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"

        print(upload)
        var startUpload = agoFormatter.date(from: upload)
        let distanceSecond = Calendar.current.dateComponents([.minute], from: startUpload ?? Date(), to: nowDate).minute
        titleSchedule = titleFormatter.string(from: start)
        finishSchedule = finishFormatter.string(from: start)
        
        scheduleDateString = startFormatter.string(from: start) + "~" + finishFormatter.string(from: finish)
        
        if distanceSecond! < 1{
            timeAgo = "1m ago"
        }
        else if distanceSecond! < 15{
            timeAgo = "15m ago"
        }
        else if distanceSecond! < 30{
            timeAgo = "30m ago"
        }
        else if distanceSecond! < 60{
            timeAgo = "60m ago"
        }
        else{
            timeAgo = "long time ago"
        }
        
    }
//MARK: RefreshTableView
    func initRefresh(){
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(updateUI(refresh:)), for: .valueChanged)
        
        if #available(iOS 10.0, *){
            tableView.refreshControl = refresh
        }else{
            tableView.addSubview(refresh)
        }
    }
    
    @objc func updateUI(refresh: UIRefreshControl){
        refresh.endRefreshing()
        tableViewReloadDelegate()
        tableView.reloadData()
    }
    
//MARK: GetDataFunction
    func uppdateProfile(){
        GetProfileDataService.ProfileData.getRecommendInfo{ (response) in
            switch(response)
            {
            case .success(let loginData):
                self.setProfile()
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
    func getScheduleData(){
        GetScheduleNoticeDataService.scheduleData.getRecommendInfo{ (response) in
            switch(response)
            {
            case .success(let loginData):
                if let response = loginData as? ScheduleNoticeModel{
                    self.tableView.backgroundView = .none
                    self.tableView.backgroundColor = UIColor.mainGray
                    DispatchQueue.global().async {
                        self.scheduleData.append(response)
                    }
                    self.tableView.reloadData()
                }
            case .requestErr(let message):
                print("requestERR")
            case .pathErr :
                print("pathERR")
            case .serverErr:
                print("serverERR")
            case .networkFail:
                print("networkFail")
                    self.tableView.backgroundView = UIImageView(image: UIImage(named: "mainNoSCBackground.png"))
            }
        }
    }
    
//MARK: IBOutletFunction
    
    @IBAction func settingButtonClicked(_ sender: Any) {
        guard let SettingVC = UIStoryboard(name: "Setting", bundle: nil).instantiateViewController(identifier: "SettingVC") as? SettingVC else {return}
        self.navigationController?.pushViewController(SettingVC, animated: true)
        print(navigationController)
        
    }
    @IBAction func calendarButtonClicked(_ sender: Any) {
        guard let calendarVC = UIStoryboard(name: "Calendar", bundle: nil).instantiateViewController(identifier: "CalendarVC") as? CalendarVC else {return}
        self.navigationController?.pushViewController(calendarVC, animated: true)
    }
    
    
    

}
//MARK: Extension
extension HomeVC: UITableViewDelegate{
    
}
extension HomeVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: HomeTVC = tableView.dequeueReusableCell(withIdentifier: HomeTVC.identifier) as! HomeTVC
        cell.clipsToBounds = true
        cell.layer.cornerRadius = 20
        changeDate(start: scheduleData[0].calendars[indexPath.section].startDate, finish: scheduleData[0].calendars[indexPath.section].endDate, upload: scheduleData[0].calendars[indexPath.section].createdAt)
        cell.setData(date: titleSchedule, info: scheduleData[0].calendars[indexPath.section].comment, ago: timeAgo)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if scheduleData.count == 0{
            return 0
        }
        else{
            return scheduleData[0].calendars.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailVC = UIStoryboard(name: "ScheduleDetail", bundle: nil).instantiateViewController(identifier: "ScheduleDetailVC") as? ScheduleDetailVC else {return}
        self.present(detailVC, animated: true, completion: nil)
        detailVC.setData(time: scheduleDateString, information: scheduleData[0].calendars[indexPath.section].comment, person: scheduleData[0].calendars[indexPath.section].creatorName, scheduleID: scheduleData[0].calendars[indexPath.section].id)
        detailVC.delegate = self
        
    }
}

extension HomeVC: tableViewReloadDelegate{
    func tableViewReloadDelegate() {
        scheduleData = []
        getScheduleData()
        self.tableView.reloadData()
    }
}
