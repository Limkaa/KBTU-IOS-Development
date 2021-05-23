//
//  AccountTableViewCell.swift
//  SaveMoney
//
//  Created by Alim on 21.04.2021.
//

import UIKit

class AccountTableViewCell: UITableViewCell {

    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var imageType: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var balance: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
