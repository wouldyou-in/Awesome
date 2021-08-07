//
//  TermPickerVC.swift
//  Awesome
//
//  Created by 박익범 on 2021/08/05.
//

import UIKit

class TermPickerVC: UIViewController {

//MARK: IBOutlet
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
//MARK: VAR
    var startDelegate: dateData?
    var endDelegate: dateData?
    var chooseDate: String = ""
    let appdelegate = UIApplication.shared.delegate as! AppDelegate

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        changed()
    }
//MARK: func
    func setLayout(){
        appdelegate.shouldSupportAllOrientation = false
        okButton.clipsToBounds = true
        okButton.layer.cornerRadius = 15
        okButton.backgroundColor = UIColor.mainPink
        okButton.titleLabel?.font = UIFont.gmarketSansBoldFont(ofSize: 18)
        okButton.titleLabel?.textColor = UIColor.white
    }
    func changed(){
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = .short
        dateformatter.timeStyle = .none
        chooseDate = dateformatter.string(from: datePicker.date)
    }
//MARK: IBAction
    @IBAction func okButtonClicked(_ sender: Any) {
        startDelegate?.startDataSend(data: chooseDate)
        endDelegate?.finishDateSend(data: chooseDate)
        self.dismiss(animated: true, completion: nil)
        
    }
    @IBAction func datePickerSelected(_ sender: Any) {
        changed()
    }
}
