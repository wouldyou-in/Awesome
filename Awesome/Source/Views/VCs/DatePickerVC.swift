//
//  DatePickerVC.swift
//  Awesome
//
//  Created by 박익범 on 2021/08/01.
//

import UIKit

protocol dateData {
    func startDataSend(data : String)
    func finishDateSend(data : String)
}


class DatePickerVC: UIViewController {
    
//MARK: viewDidLoad
    @IBOutlet weak var pickerView: UIDatePicker!
    var chooseDate: String = ""
    var startDelegate: dateData?
    var endDelegate: dateData?
    @IBOutlet weak var okButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func datepickerSelected(_ sender: Any) {
        changed()
    }
    func setLayout(){
        okButton.backgroundColor = UIColor.mainPink
        okButton.clipsToBounds = true
        okButton.layer.cornerRadius = 15
    }
    
    func changed(){
           let dateformatter = DateFormatter()
           dateformatter.dateStyle = .none
        dateformatter.timeStyle = .short
        dateformatter.locale = Locale(identifier: "en_GB")
        print(pickerView.date)
        chooseDate = dateformatter.string(from: pickerView.date)
           
    }
    @IBAction func okButtonClicked(_ sender: Any) {
        startDelegate?.startDataSend(data: chooseDate)
        endDelegate?.finishDateSend(data: chooseDate)
        self.dismiss(animated: true, completion: nil)
        print(chooseDate)
    }
}
