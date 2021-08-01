//
//  NoScheduleDatePickerVC.swift
//  Awesome
//
//  Created by 박익범 on 2021/08/01.
//

import UIKit

class NoScheduleDatePickerVC: UIViewController {
//MARK: IBOulet
    @IBOutlet weak var pickerView: UIDatePicker!
    @IBOutlet weak var okButton: UIButton!
    
//MARK: var
    var chooseDate : String = ""
    var startDelegate : dateData?
    var endDelegate: dateData?

    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()

        // Do any additional setup after loading the view.
    }
//MARK: func
    func setLayout(){
        okButton.backgroundColor = UIColor.mainPink
        okButton.clipsToBounds = true
        okButton.layer.cornerRadius = 15
    }

    func changed(){
           let dateformatter = DateFormatter()
        dateformatter.dateStyle = .short
           dateformatter.timeStyle = .none
        chooseDate = dateformatter.string(from: pickerView.date)
    }
    
//MARK: IBAction
    @IBAction func datepickerSelected(_ sender: Any) {
        changed()
    }
    @IBAction func okButtonClicked(_ sender: Any) {
        startDelegate?.startDataSend(data: chooseDate)
        endDelegate?.finishDateSend(data: chooseDate)
        self.dismiss(animated: true, completion: nil)
    }

}
