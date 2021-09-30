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
    var isFirstLoginBool: Bool = false
    var isNoCell: Bool = false
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    var cnt = 99;

//MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        uppdateProfile()
        getScheduleData()
        setHeaderUI()
        setTableView()
        setIdentifier()
        initRefresh()
        isFirstLogin()
        postDeviceToken()
        if UserDefaults.standard.bool(forKey: "beta") != true{
            self.makeAlert(title: "알림", message: "초대장이 없으면 프로필이 보이지 않고 기능을 사용할 수 없어요😢 초대장을 받아 앱의 모든 기능을 이용해봐요!", okAction: nil, completion: nil)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
   
    
//MARK: function
    func postDeviceToken(){
        if UserDefaults.standard.bool(forKey: "noti") == true{
        PostDevieceTokenDataService.shared.AutoLoginService(push_token: UserDefaults.standard.string(forKey: "deviceToken")!) { [self] result in
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
    }

    func setIdentifier(){
        tableView.registerCustomXib(xibName: "HomeTVC")
        tableView.registerCustomXib(xibName: "HomeNotScheduleTVC")

    }
    
    func isFirstLogin(){
        guard let apnVC = UIStoryboard(name: "AskApn", bundle: nil).instantiateViewController(identifier: "AskApnVC") as? AskApnVC else {return}
        if isFirstLoginBool == true {
            self.present(apnVC, animated: true, completion: nil)
        }
    }
    
    func setHeaderUI(){
//        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
//        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        appdelegate.shouldSupportAllOrientation = false
        
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
        let ipadScale = screenWith/600
        let buttonWidth = settingButton.frame.width
        let buttonHeigth = settingButton.frame.width
        
        if screenWith > 500{
            settingButton.frame.size = CGSize(width: buttonWidth * ipadScale, height: buttonHeigth * ipadScale)
        }
        else{
            settingButton.frame.size = CGSize(width: buttonWidth * scale, height: buttonHeigth * scale)
        }

    }
    
    func fontReSize(size: CGFloat) -> CGFloat{
        let screenWith = UIScreen.main.bounds.width
        let sizeFormatter = size/428
        var result: CGFloat = 0
        if screenWith > 500 {
            result = screenWith * (size/900)
        }
        else{
            result = screenWith * sizeFormatter
        }
        return result
    }
    
    func setTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
    }
    func setProfile(){
        let defaults = UserDefaults.standard
        profileName = defaults.string(forKey: "name") ?? "none"
        nameLabel.text = "HI, \(profileName)"
        
        if defaults.bool(forKey: "appleLoginSuccess") == true{
            print("애플로그인은 프사가 없읍니다..")
        }
        else {
            let url = URL(string: defaults.string(forKey: "profile")!)
                DispatchQueue.global().async { let data = try? Data(contentsOf: url!)
                    DispatchQueue.main.async { self.settingButton.setImage(UIImage(data: data!), for: .normal)}}
        }
    }
    
    func changeDate(start: String, finish: String, upload: String){
        let startFormatter = DateFormatter()
        let titleFormatter = DateFormatter()
        let finishFormatter = DateFormatter()
        let agoFormatter = DateFormatter()
        let sfFormatter = DateFormatter(
        )
        var nowDate = Date()
        
       
        sfFormatter.locale = Locale(identifier: "ko_KR")
        sfFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        startFormatter.locale = Locale(identifier: "ko_KR")
        startFormatter.dateFormat = "MM월 dd일 HH:mm"
        finishFormatter.locale = Locale(identifier: "ko_KR")
        finishFormatter.dateFormat = "HH:mm"
        titleFormatter.dateFormat = "yyyy년 MM월 dd일"
        agoFormatter.locale = Locale(identifier: "ko_KR")
        agoFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"

        var startDay = sfFormatter.date(from: start)
        var endDay = sfFormatter.date(from: finish)
        var startUpload = agoFormatter.date(from: upload)
        
        print(startDay, endDay, startUpload)

        let distanceSecond = Calendar.current.dateComponents([.minute], from: startUpload ?? Date(), to: nowDate).minute
        
        
        titleSchedule = titleFormatter.string(from: startDay ?? Date())
        finishSchedule = finishFormatter.string(from: endDay ?? Date())
        print(startFormatter.string(from: startDay!))
        scheduleDateString = startFormatter.string(from: startDay ?? Date()) + "~" + finishFormatter.string(from: endDay ?? Date())
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
        refresh.fs_height = 200
        refresh.addTarget(self, action: #selector(updateUI(refresh:)), for: .valueChanged)
//        var refreshImage = UIImage(named: "refreshControl")
//        var backgroundView = UIImageView(image: refreshImage)
//        backgroundView.center.x = (UIScreen.main.bounds.width/2) - 34
//        tableView.backgroundView = UIImageView(image: UIImage(named: "refreshControl"))
//        refresh.tintColor = .clear
//        refresh.addSubview(backgroundView)
        refresh.backgroundColor = .mainGray
        if #available(iOS 10.0, *){
            self.tableView.refreshControl = refresh
        }else{
            tableView.addSubview(refresh)
        }
    }
    
    @objc func updateUI(refresh: UIRefreshControl){
        tableViewReloadDelegate()
        tableView.reloadData()
        refresh.endRefreshing()

    }


//MARK: GetDataFunction
    func uppdateProfile(){
        GetProfileDataService.ProfileData.getRecommendInfo{ (response) in
            switch(response)
            {
            case .success(let loginData):
                self.setProfile()
                UserDefaults.standard.setValue(true, forKey: "beta")
            case .requestErr(let message):
                print("requestERR")
            case .pathErr :
                print("pathERR")
            case .serverErr:
                print("serverERR")
            case .networkFail:
                UserDefaults.standard.setValue(false, forKey: "beta")
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
//                    self.tableView.backgroundView = UIImageView(image: UIImage(named: "mainNoSCBackground.png"))
            }
        }
        func deleteBlockSchedule(){
        
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
        let noCell: HomeNotScheduleTVC = tableView.dequeueReusableCell(withIdentifier: HomeNotScheduleTVC.identifier) as! HomeNotScheduleTVC
        cell.clipsToBounds = true
        cell.layer.cornerRadius = 20
        
        if isNoCell == true{
            tableView.isSpringLoaded = true
            return noCell
        }
        else{
        changeDate(start: scheduleData[0].calendars[indexPath.section].startDate, finish: scheduleData[0].calendars[indexPath.section].endDate, upload: scheduleData[0].calendars[indexPath.section].createdAt)
        cell.setData(date: titleSchedule, info: scheduleData[0].calendars[indexPath.section].comment, ago: timeAgo)
        return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isNoCell == true{
            return UIScreen.main.bounds.height - 150
        }
        else{
        return 110
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.5
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if scheduleData.count == 0{
            isNoCell = true
            return 1
        }
        else{
            isNoCell = false
            return scheduleData[0].calendars.count
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailVC = UIStoryboard(name: "ScheduleDetail", bundle: nil).instantiateViewController(identifier: "ScheduleDetailVC") as? ScheduleDetailVC else {return}
        
        if isNoCell == false{
        self.present(detailVC, animated: true, completion: nil)
            changeDate(start: scheduleData[0].calendars[indexPath.section].startDate, finish: scheduleData[0].calendars[indexPath.section].endDate, upload: scheduleData[0].calendars[indexPath.section].createdAt)
            detailVC.setData(time: scheduleDateString, information: scheduleData[0].calendars[indexPath.section].comment, person: scheduleData[0].calendars[indexPath.section].creatorName, scheduleID: scheduleData[0].calendars[indexPath.section].id)
        detailVC.delegate = self
            print(indexPath.section)
        }
        else{
            print("없는셀 클릭")
        }
        
    }
}

extension HomeVC: tableViewReloadDelegate{
    func tableViewReloadDelegate() {
            scheduleData = []
        Thread.sleep(forTimeInterval: 0.05)
            getScheduleData()
        self.tableView.reloadData()
    }
}



