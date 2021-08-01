//
//  ScheduleDetailVC.swift
//  Awesome
//
//  Created by 박익범 on 2021/08/02.
//

import UIKit

class ScheduleDetailVC: UIViewController {
//MARK: IBOulet
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var promiseObject: UILabel!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var subjectView: UIView!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var denineButton: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var headerLabelConstraint: NSLayoutConstraint!
    
//MARK: Var
    let width = UIScreen.main.bounds.width

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabelFont()
        setRadius()
        setDetailLabel()

    }
//MARK: Function
    func setLabelFont(){
        headerLabelConstraint.constant = headerLabelConstraint.constant * (width/428)
    }
    func setData(time : String , information : String, person : String){
        nameLabel.text = person
        timeLabel.text = time
        promiseObject.text = information
    }
    func setDetailLabel(){
        promiseObject.lineBreakStrategy = .hangulWordPriority
        promiseObject.numberOfLines = 5
    }
    func setRadius(){
        backgroundView.clipsToBounds = true
        backgroundView.layer.cornerRadius = 12
        nameView.clipsToBounds = true
        nameView.layer.cornerRadius = 12
        timeView.clipsToBounds = true
        timeView.layer.cornerRadius = 12
        subjectView.clipsToBounds = true
        subjectView.layer.cornerRadius = 12
        acceptButton.clipsToBounds = true
        acceptButton.layer.cornerRadius = 20
        denineButton.clipsToBounds = true
        denineButton.layer.cornerRadius = 20
        self.view.backgroundColor = .none
    }
//MARK: IBAction
    @IBAction func acceptButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func denineButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
