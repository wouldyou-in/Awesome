//
//  HomeTVC.swift
//  Awesome
//
//  Created by 박익범 on 2021/07/28.
//

import UIKit

class HomeTVC: UITableViewCell {

//MARK: IBOulet
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var agoLabel: UILabel!
    
    static let identifier: String = "HomeTVC"
    

    override func awakeFromNib() {
        super.awakeFromNib()
        setLabelUI()
        // Initialization code
    }
//MARK: Funcion
    
    func setLabelUI(){
        dateLabel.font = UIFont.gmarketSansBoldFont(ofSize: 16)
        infoLabel.font = UIFont.gmarketSansMediumFont(ofSize: 14)
        agoLabel.font = UIFont.gmarketSansMediumFont(ofSize: 14)
        dateLabel.textColor = UIColor.black
        infoLabel.textColor = UIColor.black
        agoLabel.textColor = UIColor.textGray
        
    }
    func setData(date: String, info: String, ago: String){
        dateLabel.text = date
        infoLabel.text = info
        agoLabel.text = ago
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
        // Configure the view for the selected state
    }
    
}
