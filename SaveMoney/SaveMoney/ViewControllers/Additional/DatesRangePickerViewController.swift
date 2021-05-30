//
//  DatesRangePickerViewController.swift
//  SaveMoney
//
//  Created by Alim on 29.05.2021.
//

import UIKit

class DatesRangePickerViewController: UIViewController {

    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var datesRangeLabel: UILabel!
    @IBOutlet weak var dateFromPicker: UIDatePicker!
    @IBOutlet weak var dateTillPicker: UIDatePicker!
    
    var datesRange = DatesRange(type: .custom)
    var delegate: DateRangeSave!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewElements()
    }
    
    func setupViewElements() {
        bottomView.layer.cornerRadius = 30
        cancelButton.layer.cornerRadius = 20
        saveButton.layer.cornerRadius = 20
        dateFromPicker.setDate(datesRange.from, animated: true)
        dateTillPicker.setDate(datesRange.till, animated: true)
        setupDateRangeLabel()
    }
    
    func setupDateRangeLabel() {
        datesRangeLabel.text = datesRange.toString()
    }
    
    @IBAction func dateFromChanged(_ sender: Any) {
        datesRange.from = dateFromPicker.date
        setupDateRangeLabel()
    }
    
    @IBAction func dateTillChanged(_ sender: Any) {
        datesRange.till = dateTillPicker.date
        setupDateRangeLabel()
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func savePressed(_ sender: Any) {
        delegate.saveDateRange(datesRange: datesRange)
        self.dismiss(animated: true, completion: nil)
    }
}
