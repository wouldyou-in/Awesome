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
    let profileName: String = ""

//MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        uppdateProfile()
        setHeaderUI()
        setTableView()
        setIdentifier()
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
        settingButton.layer.masksToBounds = false
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
        nameLabel.text = defaults.string(forKey: "name") ?? "none"
        
        let url = URL(string: defaults.string(forKey: "profile") ?? "none")
            DispatchQueue.global().async { let data = try? Data(contentsOf: url!)
                DispatchQueue.main.async { self.settingButton.setImage(UIImage(data: data!), for: .normal)}}
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
        cell.setData(date: "222", info: "222", ago: "222")
        
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailVC = UIStoryboard(name: "ScheduleDetail", bundle: nil).instantiateViewController(identifier: "ScheduleDetailVC") as? ScheduleDetailVC else {return}
        self.present(detailVC, animated: true, completion: nil)
        detailVC.setData(time: "222", information: "222", person: "222")
        print(indexPath.section)
    }
}
