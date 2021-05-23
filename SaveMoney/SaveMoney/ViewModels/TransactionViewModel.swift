//
//  TransactionViewModel.swift
//  SaveMoney
//
//  Created by Alim on 12.05.2021.
//

import Foundation
import UIKit
import CoreData

enum TransactionType: Int {
    case income = 1
    case expense = 2
    case transfer = 3
    case unknown = 0
}

struct TransactionViewModel {
    var amount: Int32 = 0
    var date: Date = Date()
    var comment: String!
    var sourceTitle: String = "unknown"
    var destinationTitle: String = "unknown"
    var icon = UIImage.init(systemName: "arrow.right.square")
    
    var transactionType: TransactionType = .unknown
    var typeColor = UIColor.systemOrange
    var typeSign = ""
    var instance: Transaction!
    
    var amountString: String {
        return String(format: "%@ %@", typeSign, amount.formattedWithSeparator)
    }
    
    init(transaction: Transaction) {
        self.instance = transaction
        self.amount = transaction.amount
        self.comment = "Comment: \(transaction.comment ?? "--")"
        self.date = transaction.date!
        self.transactionType = TransactionType(rawValue: Int(transaction.type))!
        
        switch transaction.type {
        case 1:
            self.sourceTitle = "From: incomes"
            self.destinationTitle = "\(transaction.toAccount?.title! ?? "unknown")"
            self.typeColor = UIColor.systemGreen
            self.typeSign = "+"
            
        case 2:
            self.sourceTitle = "From: \(transaction.fromAccount?.title! ?? "unknown")"
            self.destinationTitle = "\(transaction.toCategory?.name! ?? "unknown")"
            if transaction.toCategory != nil {
                self.icon = UIImage.init(named: (transaction.toCategory?.iconPath)!)
            }
            self.typeColor = UIColor.systemRed
            self.typeSign = "-"
            
        case 3:
            self.sourceTitle = "From: \(transaction.fromAccount?.title! ?? "unknown")"
            self.destinationTitle = "\(transaction.toAccount?.title! ?? "unknown")"
            self.typeColor = UIColor.lightGray
        case 0:
            break
        default:
            break
        }
    }
}

