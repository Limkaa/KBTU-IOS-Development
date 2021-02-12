//
//  AddContactViewController.swift
//  ContactBook
//
//  Created by Alim on 11.02.2021.
//

import UIKit

class AddContactViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var myTable: UITableView!
    var contactBook: ContactBook!
    var gender: String = "male"
    
    @IBOutlet weak var contactNameField: UITextField!
    @IBOutlet weak var contactPhoneNumber: UITextField!
    @IBOutlet weak var contactGender: UIPickerView!
    
    var pickerData: [String] = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.contactGender.delegate = self
        self.contactGender.dataSource = self
        pickerData = ["male", "female"]
    }
    
    @IBAction func addContact(_ sender: UIButton) {
        contactBook.addContact(Contact(contactNameField.text!, contactPhoneNumber.text!, gender))
        myTable.reloadData()
        navigationController?.popViewController(animated: true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {return 1}
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        gender = pickerData[row]
    }
    
}
