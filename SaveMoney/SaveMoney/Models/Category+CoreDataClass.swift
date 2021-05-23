//
//  Category+CoreDataClass.swift
//  SaveMoney
//
//  Created by Alim on 13.05.2021.
//
//

import Foundation
import CoreData

@objc(Category)
public class Category: NSManagedObject {
    
    // Get all transactions of exact category
    func getTransactions() -> NSFetchRequest<Transaction> {
        let request = Transaction.fetchRequest() as NSFetchRequest<Transaction>
        let predicate = NSPredicate(format: "toCategory == \(self.id)")
        let sort = NSSortDescriptor(keyPath: \Transaction.date, ascending: false)
        request.sortDescriptors = [sort]
        request.predicate = predicate
        return request
    }
    
    // Get all transactions of exact category per period
    func getTransactions(from: Date, till: Date) -> NSFetchRequest<Transaction> {
        let request = Transaction.fetchRequest() as NSFetchRequest<Transaction>
        let predicate = NSPredicate(format: "date >= %@ AND date <= %@ AND toCategory == %@", from as NSDate, till as NSDate, self)
        let sort = NSSortDescriptor(keyPath: \Transaction.date, ascending: false)
        request.sortDescriptors = [sort]
        request.predicate = predicate
        return request
    }
    
}
