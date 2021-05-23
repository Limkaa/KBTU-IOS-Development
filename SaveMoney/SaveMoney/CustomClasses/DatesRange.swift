//
//  DatesRange.swift
//  SaveMoney
//
//  Created by Alim on 12.05.2021.
//

import Foundation

enum DateRangeType: Int {
    case all = 0
    case year = 1
    case month = 2
    case week = 3
    case day = 4
    case custom = 5
}

class DatesRange {

    var dateRangeType: DateRangeType = .all
    
    var from: Date = Date().startOfDay
    var till: Date = Date().endOfDay
    
    init(type: DateRangeType = .all) {
        dateRangeType = type
        setupDatesRange(type: type)
    }
    
    func setupDatesRange(type: DateRangeType) {
        let now = Date()
        let cal = Calendar(identifier: .gregorian)
        dateRangeType = type
        
        switch type {
        case .all:
            from = Date(timeIntervalSince1970: 0)
            till = Date().endOfDay
        case .year:
            let components = cal.dateComponents([.year], from: now)
            from = cal.date(from: components) ?? Date()
            till = cal.date(byAdding: DateComponents(year: 1, second: -1), to: from) ?? Date()
        case .month:
            let components = cal.dateComponents([.year, .month], from: now)
            from = cal.date(from: components) ?? Date()
            till = cal.date(byAdding: DateComponents(month: 1, second: -1), to: from) ?? Date()
        case .week:
            let components = cal.dateComponents([.year, .month, .weekOfYear], from: now)
            from = cal.date(from: components) ?? Date()
            till = cal.date(byAdding: DateComponents(second: -1, weekOfYear: 1), to: from) ?? Date()
        case .day:
            let components = cal.dateComponents([.year, .month, .day], from: now)
            from = cal.date(from: components) ?? Date()
            till = cal.date(byAdding: DateComponents(day: 1, second: -1), to: from) ?? Date()
        case .custom:
            from = Date(timeIntervalSince1970: 0)
            till = Date().endOfDay
        }
    }
    
    func getAnotherPeriodByStep(step: Int = 1) {
        let cal = Calendar(identifier: .gregorian)
        switch self.dateRangeType {
        case .all:
            from = Date(timeIntervalSince1970: 0)
            till = Date().endOfDay
        case .year:
            from = cal.date(byAdding: DateComponents(year: step), to: from)?.startOfDay ?? Date()
            till = cal.date(byAdding: DateComponents(year: step), to: till)?.endOfDay ?? Date()
        case .month:
            from = cal.date(byAdding: DateComponents(month: step), to: from)?.startOfDay ?? Date()
            till = from.endOfMonth
        case .week:
            from = cal.date(byAdding: DateComponents(weekOfYear: step), to: from)?.startOfDay ?? Date()
            till = cal.date(byAdding: DateComponents(weekOfYear: step), to: till)?.endOfDay ?? Date()
        case .day:
            from = cal.date(byAdding: DateComponents(day: step), to: from)?.startOfDay ?? Date()
            till = cal.date(byAdding: DateComponents(day: step), to: till)?.endOfDay ?? Date()
        case .custom:
            from = Date(timeIntervalSince1970: 0)
            till = Date().endOfDay
        }
    }
    
    func toString() -> String {
        switch self.dateRangeType {
        case .all:
            return "All time"
        case .year:
            return "\(till.yearString)"
        case .month:
            return "\(till.monthString)"
        case .week:
            return "\(from.dayString) - \(till.dayString)"
        case .day:
            return "\(till.dayString)"
        case .custom:
            return "\(from.dayString) - \(till.dayString)"
        }
    }
}
