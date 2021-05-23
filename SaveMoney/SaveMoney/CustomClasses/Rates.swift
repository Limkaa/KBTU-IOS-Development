//
//  Rates.swift
//  SaveMoney
//
//  Created by Alim on 13.05.2021.
//

import Foundation

struct Rates {
    var income: Money = Money(amount: 0)
    var expense: Money = Money(amount: 0)
    
    var from: Date?
    var till: Date?
    
    var cashFlow: Money {
        return Money(amount: income.amountUnsigned - expense.amountUnsigned)
    }
}
