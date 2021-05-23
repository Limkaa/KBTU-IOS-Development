//
//  AddDetailsViewController.swift
//  SaveMoney
//
//  Created by Alim on 11.05.2021.
//

import UIKit

class AddDetailsViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    var delegate: OperationDetailsSave!
    var currentText = ""
    var currentDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewElements()
        
    }
    
    func setupViewElements() {
        bottomView.layer.cornerRadius = 30
        
        commentTextView.layer.borderColor = UIColor.lightGray.cgColor
        commentTextView.layer.borderWidth = 1
        commentTextView.layer.cornerRadius = 15
        commentTextView.layer.masksToBounds = true
        commentTextView.text = currentText
        
        datePicker.setDate(currentDate, animated: true)
        datePicker.maximumDate = Date()
        
        cancelButton.layer.cornerRadius = 20
        saveButton.layer.cornerRadius = 20
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func savePressed(_ sender: Any) {
        delegate.saveDetails(date: datePicker.date, comment: commentTextView.text)
        self.dismiss(animated: true, completion: nil)
    }
}
