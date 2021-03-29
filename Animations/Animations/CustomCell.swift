//
//  CustomCell.swift
//  Animations
//
//  Created by Alim on 29.03.2021.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var details: UILabel!
    @IBOutlet weak var infoButton: UIButton!
    var additionalView = UIView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func infoPressed(_ sender: UIButton) {
    }
}
