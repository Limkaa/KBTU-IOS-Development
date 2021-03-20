//
//  NewAlarmViewController.swift
//  Midterm
//
//  Created by Alim on 12.03.2021.
//

import UIKit

protocol AddAlarm {
    func addAlarm(time: String, note: String)
}
class NewAlarmViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var noteField: UITextField!
    var delegate: AddAlarm?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H:mm"
        let time = dateFormatter.string(from: datePicker.date)
        delegate?.addAlarm(time: time, note: (noteField?.text)!)
        self.dismiss(animated: true, completion: nil)
    }
    
}
