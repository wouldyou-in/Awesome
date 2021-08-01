//
//  NoScheduleVC.swift
//  Awesome
//
//  Created by 박익범 on 2021/08/01.
//

import UIKit

class NoScheduleVC: UIViewController {
//MARK: IBOulet
    
    @IBOutlet weak var startTimeButton: UIButton!
    @IBOutlet weak var sellectButton: UIButton!
    @IBOutlet weak var finishTimeButton: UIButton!
    @IBOutlet weak var backGroundView: UIView!
    
    
//MARK: var
    var startTime: String = ""
    var endTime: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRound()

    }
    
    func setRound(){
        startTimeButton.clipsToBounds = true
        startTimeButton.layer.cornerRadius = 20
        sellectButton.clipsToBounds = true
        sellectButton.layer.cornerRadius = 20
        backGroundView.clipsToBounds = true
        backGroundView.layer.cornerRadius = 20
        finishTimeButton.clipsToBounds = true
        finishTimeButton.layer.cornerRadius = 20
        self.view.backgroundColor = .none
    }
    
  
    @IBAction func selectButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension NoScheduleVC: dateData{
    func startDataSend(data: String) {
        startTimeButton.setTitle(data, for: .normal)
        startTime = data
    }
    
    func finishDateSend(data: String) {
        finishTimeButton.setTitle(data, for: .normal)
        endTime = data
    }
    
    @IBAction func startTimeButtonClicked(_ sender: Any) {
        guard let startVC = UIStoryboard(name: "NoScheduleDatePicker", bundle: nil).instantiateViewController(identifier: "NoScheduleDatePickerVC") as? NoScheduleDatePickerVC else {return}
        self.present(startVC, animated: true, completion: nil)
        startVC.startDelegate = self
    }
    
    @IBAction func finishTimeButtonClicked(_ sender: Any) {
        guard let finishVC = UIStoryboard(name: "NoScheduleDatePicker", bundle: nil).instantiateViewController(identifier: "NoScheduleDatePickerVC") as? NoScheduleDatePickerVC else {return}
        self.present(finishVC, animated: true, completion: nil)
        finishVC.endDelegate = self
    }
}
