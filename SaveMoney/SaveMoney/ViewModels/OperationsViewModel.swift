//
//  OperationsViewModel.swift
//  SaveMoney
//
//  Created by Alim on 12.05.2021.
//

import Foundation
import UIKit
import CoreData

class OperationsViewModel {
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var requestedTransactions = [[Transaction]]()
    var datesRange = DatesRange()
    var moneyRates = Rates()
    
    func getTransactions() {
        let request = Transaction.getTransactions(from: datesRange.from, till: datesRange.till)
        requestedTransactions = Transaction.groupRequestedTransactions(transactions: try! context.fetch(request))
        getMoneyRates(request: request)
    }
    
    func getMoneyRates(request: NSFetchRequest<Transaction>) {
        let amounts = try! context.fetch(Transaction.getAmountOfTransactions(request: request))
        moneyRates.income.amount = Transaction.getAmount(result: amounts, type: .income)
        moneyRates.expense.amount = Transaction.getAmount(result: amounts, type: .expense)
    }
    
    func deleteOperation(indexPath: IndexPath) {
        let operationToDelete = requestedTransactions[indexPath.section][indexPath.row]
        let preparedOperationForDeletion = operationToDelete.preDeleteOperation()
        context.delete(preparedOperationForDeletion)
        try! context.save()
    }
}
