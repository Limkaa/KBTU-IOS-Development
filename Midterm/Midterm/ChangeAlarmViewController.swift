//
//  ChangeAlarmViewController.swift
//  Midterm
//
//  Created by Alim on 12.03.2021.
//

import UIKit

protocol ChangeAlarm {
    func changeAlarmInfo(time: String, note: String, index: Int)
}

protocol DeleteAlarm {
    func deleteAlarm(index: Int)
}

class ChangeAlarmViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var noteField: UITextField!
    var currentAlarm: Alarm!
    
    var alarmIndex: Int!
    var delegate: (ChangeAlarm & DeleteAlarm)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        datePicker.setDate(dateFormatter.date(from: currentAlarm.time)!, animated: false)
        noteField.text = currentAlarm.note
    }
    
    @IBAction func deletePressed(_ sender: UIButton) {
        delegate?.deleteAlarm(index: alarmIndex)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func changePressed(_ sender: UIButton) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H:mm"
        let time = dateFormatter.string(from: datePicker.date)
        delegate?.changeAlarmInfo(time: time, note: (noteField?.text)!, index: alarmIndex)
        navigationController?.popViewController(animated: true)
    }
}
