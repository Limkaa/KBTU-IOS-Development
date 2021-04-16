//
//  PersonalTweetTableViewCell.swift
//  Twitter
//
//  Created by Alim on 15.04.2021.
//

import UIKit

class PersonalTweetTableViewCell: UITableViewCell {

    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var emailField: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var dateField: UILabel!
    @IBOutlet weak var textField: UILabel!
    @IBOutlet weak var hashtagsField: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
