//
//  NoScheduleTVC.swift
//  Awesome
//
//  Created by 박익범 on 2021/07/30.
//

import UIKit

class NoScheduleTVC: UITableViewCell {
    
    static let identifier: String = "NoScheduleTVC"

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
        backgroundColor = UIColor.white
    }
    
}
