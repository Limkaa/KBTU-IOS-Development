//
//  Transaction+CoreDataClass.swift
//  SaveMoney
//
//  Created by Alim on 13.05.2021.
//
//

import Foundation
import CoreData

@objc(Transaction)
public class Transaction: NSManagedObject {

}

extension Transaction {
    
    // Get all transactions
    static func getTransactions() -> NSFetchRequest<Transaction> {
        let request = Transaction.fetchRequest() as NSFetchRequest<Transaction>
        let sort = NSSortDescriptor(keyPath: \Transaction.date, ascending: false)
        request.sortDescriptors = [sort]
        return request
    }
    
    
    // Get all transactions of exact type
    static func getTransactions(type: TransactionType) -> NSFetchRequest<Transaction> {
        let request = Transaction.fetchRequest() as NSFetchRequest<Transaction>
        let predicate = NSPredicate(format: "type == %@", type.rawValue)
        let sort = NSSortDescriptor(keyPath: \Transaction.date, ascending: false)
        request.sortDescriptors = [sort]
        request.predicate = predicate
        return request
    }
    
    
    // Get all transactions of some period of time
    static func getTransactions(from: Date, till: Date) -> NSFetchRequest<Transaction> {
        let request = Transaction.fetchRequest() as NSFetchRequest<Transaction>
        let predicate = NSPredicate(format: "date >= %@ AND date <= %@", from as NSDate, till as NSDate)
        let sort = NSSortDescriptor(keyPath: \Transaction.date, ascending: false)
        request.sortDescriptors = [sort]
        request.predicate = predicate
        return request
    }
    
    
    // Get all transactions of some period of time and with exact type
    static func getTransactions(from: Date, till: Date, type: TransactionType) -> NSFetchRequest<Transaction> {
        let request = Transaction.fetchRequest() as NSFetchRequest<Transaction>
        let predicate = NSPredicate(format: "date >= %@ AND date <= %@ AND type = %@", from as NSDate, till as NSDate, type.rawValue as NSNumber)
        let sort = NSSortDescriptor(keyPath: \Transaction.date, ascending: false)
        request.sortDescriptors = [sort]
        request.predicate = predicate
        return request
    }
    
    
    // Get amount of operations of the requested transactions
    static func getAmountOfTransactions(request: NSFetchRequest<Transaction>) -> NSFetchRequest<NSDictionary> {
        let keypath = NSExpression(forKeyPath: "amount")
        let expression = NSExpression(forFunction: "sum:", arguments: [keypath])
        let rate = NSExpressionDescription()
        rate.expression = expression
        rate.name = "amount"
        rate.expressionResultType = .integer64AttributeType
        
        let amountsRequest = NSFetchRequest<NSDictionary>(entityName: "Transaction")
        amountsRequest.predicate = request.predicate
        amountsRequest.returnsObjectsAsFaults = false
        amountsRequest.propertiesToFetch = [rate, "type"]
        amountsRequest.propertiesToGroupBy = ["type"]
        amountsRequest.resultType = .dictionaryResultType
        
        return amountsRequest
    }
    
    
    // Parse and get amount of exact transaction type from dictionary
    static func getAmount(result: [NSFetchRequestResult], type: TransactionType) -> Int64 {
        let typeResult = result.filter { (item) -> Bool in
              guard let dict = item as? Dictionary<String, Any> else { return false }
              return dict["type"] as? Int == type.rawValue
        }
        
        if typeResult.count != 1 { return 0 }
        guard let dict = typeResult[0] as? Dictionary<String, Any> else { return 0 }
        guard let amount = dict["amount"] as? Int64 else { return 0 }

        return amount
    }
    
    
    // Group transactions by date and sort them
    static func groupRequestedTransactions(transactions: [Transaction]) -> [[Transaction]] {
        let transactionsGrouped = Dictionary(grouping: transactions) { (transaction: Transaction) -> Date in
            return (transaction.date?.middleOfDay)!
        }
        
        var requestedTransactions: [[Transaction]] = []
        let sortedDatesKeys = transactionsGrouped.keys.sorted().reversed()
        sortedDatesKeys.forEach { (key) in
            requestedTransactions.append(transactionsGrouped[key]!)
        }
        
        return requestedTransactions
    }
    
    
    // Some necessary actions before we delete operation
    func preDeleteOperation() -> Transaction {
        switch self.type {
        case 1:
            if self.toAccount != nil { self.toAccount!.amount -= self.amount }
        case 2:
            if self.fromAccount != nil {self.fromAccount!.amount += self.amount}
        case 3:
            if self.toAccount != nil {self.toAccount!.amount -= self.amount}
            if self.fromAccount != nil {self.fromAccount!.amount += self.amount}
        default:
            break 
        }
        return self
    }
}
