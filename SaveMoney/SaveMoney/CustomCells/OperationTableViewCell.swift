//
//  OperationTableViewCell.swift
//  SaveMoney
//
//  Created by Alim on 11.05.2021.
//

import UIKit

class OperationTableViewCell: UITableViewCell {

    @IBOutlet weak var operationImage: UIImageView!
    @IBOutlet weak var operationTitle: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var fromAccount: UILabel!
    @IBOutlet weak var comment: UILabel!
    var transaction: Transaction!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
