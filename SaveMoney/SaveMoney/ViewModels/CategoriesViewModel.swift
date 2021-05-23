//
//  CategoriesViewModel.swift
//  SaveMoney
//
//  Created by Alim on 14.05.2021.
//

import Foundation
import UIKit
import CoreData

class CategoriesViewModel {
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var requestedCategories = [Category]()
    var datesRange = DatesRange()
    var expenciesRates = [Int64]()
    
    func getCategories() {
        requestedCategories = try! context.fetch(Category.fetchRequest())
        expenciesRates = []
        requestedCategories.forEach { (category) in
            let request = category.getTransactions(from: datesRange.from, till: datesRange.till)
            expenciesRates.append(getMoneyRates(request: request))
        }
    }
    
    func getMoneyRates(request: NSFetchRequest<Transaction>) -> Int64 {
        let amounts = try! context.fetch(Transaction.getAmountOfTransactions(request: request))
        return Transaction.getAmount(result: amounts, type: .expense)
    }
}
