//
//  StatisticsTableViewCell.swift
//  SaveMoney
//
//  Created by Alim on 28.05.2021.
//

import UIKit

class StatisticsTableViewCell: UITableViewCell {

    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var incomeValue: UILabel!
    @IBOutlet weak var expenseValue: UILabel!
    @IBOutlet weak var cashFlowValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
