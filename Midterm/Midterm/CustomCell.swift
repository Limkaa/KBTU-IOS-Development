//
//  CustomCell.swift
//  Midterm
//
//  Created by Alim on 12.03.2021.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var alarmTime: UILabel!
    @IBOutlet weak var alarmNote: UILabel!
    @IBOutlet weak var alarmSwicth: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
