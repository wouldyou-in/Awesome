//
//  myScheduleTVC.swift
//  Awesome
//
//  Created by 박익범 on 2021/07/30.
//

import UIKit

class myScheduleTVC: UITableViewCell {
    
    static let identifier: String = "myScheduleTVC"
    
//MARK: IBOulet
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var isFinishImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setLayout()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none

        // Configure the view for the selected state
    }
    func setLayout(){
        nameLabel.font = UIFont.gmarketSansMediumFont(ofSize: 16)
        timeLabel.font = UIFont.gmarketSansMediumFont(ofSize: 14)
        backgroundColor = UIColor.white
    }
    func setData(name: String, time:String, isFinish: Bool){
        if isFinish == true{
            isFinishImageView.image = UIImage(named: "finishIcon")
        }
        else{
            isFinishImageView.image = UIImage(named: "finishIcon")
        }
        nameLabel.text = name
        timeLabel.text = time
    }
}
