//
//  Money.swift
//  SaveMoney
//
//  Created by Alim on 13.05.2021.
//

import Foundation

struct Money {
    var amount: Int64 = 0
    var amountUnsigned: Int64 {
        return abs(amount)
    }
    var toString: String {
        return (amount >= 0) ? "\(amount.formattedWithSeparator)" : "- \(amountUnsigned.formattedWithSeparator)"
    }
}
