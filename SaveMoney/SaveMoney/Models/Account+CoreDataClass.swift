//
//  Account+CoreDataClass.swift
//  SaveMoney
//
//  Created by Alim on 13.05.2021.
//
//

import Foundation
import CoreData

@objc(Account)
public class Account: NSManagedObject {
    
}

extension Account {
    
    // Get amount of operations of the requested transactions
    static func getBalanceOfAccounts(request: NSFetchRequest<Account>) -> NSFetchRequest<NSDictionary> {
        let keypath = NSExpression(forKeyPath: "amount")
        let expression = NSExpression(forFunction: "sum:", arguments: [keypath])
        let rate = NSExpressionDescription()
        rate.expression = expression
        rate.name = "amount"
        rate.expressionResultType = .integer64AttributeType
        
        let amountsRequest = NSFetchRequest<NSDictionary>(entityName: "Account")
        amountsRequest.predicate = request.predicate
        amountsRequest.returnsObjectsAsFaults = false
        amountsRequest.propertiesToFetch = [rate]
        amountsRequest.resultType = .dictionaryResultType
        
        return amountsRequest
    }
    
    
    // Parse and get amount of exact transaction type from dictionary
    static func getAmount(result: [NSFetchRequestResult]) -> Int64 {
        guard let dict = result[0] as? Dictionary<String, Any> else { return 0 }
        guard let amount = dict["amount"] as? Int64 else { return 0 }

        return amount
    }
}
