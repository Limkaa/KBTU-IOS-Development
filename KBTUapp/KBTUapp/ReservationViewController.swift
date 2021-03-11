//
//  ReservationViewController.swift
//  KBTUapp
//
//  Created by Alim on 10.03.2021.
//

import UIKit

class ReservationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var facultyField: UITextField!
    @IBOutlet weak var managerField: UITextField!
    @IBOutlet weak var meetingTimeField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    
    var delegate: ReservationShowable?
    
    let faculties = ["FIT","ISE","Business school","KSA"];
    let managers = ["manager 1", "manager 2", "manager 3"];
    let meetingTime = ["9:00", "10:00", "11:00", "12:00", "13:00", "14:00", "15:00", "16:00", "17:00", "18:00"];
    
    let facultyPicker = UIPickerView()
    let managerPicker = UIPickerView()
    let meetingTimePicker = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        facultyField.inputView = facultyPicker
        managerField.inputView = managerPicker
        meetingTimeField.inputView = meetingTimePicker
        
        facultyPicker.delegate = self
        facultyPicker.dataSource = self
        managerPicker.delegate = self
        managerPicker.dataSource = self
        meetingTimePicker.delegate = self
        meetingTimePicker.dataSource = self
        
        facultyPicker.tag = 1
        managerPicker.tag = 2
        meetingTimePicker.tag = 3
    }
    
    @IBAction func reservePressed(_ sender: Any) {
        if (!facultyField.text!.isEmpty && !managerField.text!.isEmpty &&
                !meetingTimeField.text!.isEmpty && !nameField.text!.isEmpty) {
            delegate?.showReservation(faculty: facultyField.text!,
                                      manager: managerField.text!,
                                      time: meetingTimeField.text!,
                                      name: nameField.text!)
            navigationController?.popViewController(animated: true)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return faculties.count
        case 2:
            return managers.count
        case 3:
            return meetingTime.count
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return faculties[row]
        case 2:
            return managers[row]
        case 3:
            return meetingTime[row]
        default:
            return "Data not found"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            facultyField.text = faculties[row]
            facultyField.resignFirstResponder()
        case 2:
            managerField.text = managers[row]
            managerField.resignFirstResponder()
        case 3:
            meetingTimeField.text = meetingTime[row]
            meetingTimeField.resignFirstResponder()
        default:
            return
        }
    }
    

}
