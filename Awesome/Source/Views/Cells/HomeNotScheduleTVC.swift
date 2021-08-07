//
//  HomeNotScheduleTVC.swift
//  Awesome
//
//  Created by 박익범 on 2021/08/07.
//

import UIKit

class HomeNotScheduleTVC: UITableViewCell {

    static let identifier: String = "HomeNotScheduleTVC"

    override func awakeFromNib() {
        super.awakeFromNib()
        setBackground()
        // Initialization code
    }
    
    func setBackground(){
        self.backgroundColor = UIColor.mainGray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none

        // Configure the view for the selected state
    }
    
}
