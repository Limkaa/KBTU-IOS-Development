//
//  Protocols.swift
//  SaveMoney
//
//  Created by Alim on 09.05.2021.
//

import Foundation

protocol UpdatePage {
    func reloadData()
}

protocol OptionChoosed {
    func optionChoose(array: [NSObject], index: Int)
}

protocol OperationDetailsSave {
    func saveDetails(date: Date, comment: String)
}

protocol DateRangeSave {
    func saveDateRange(datesRange: DatesRange)
}
