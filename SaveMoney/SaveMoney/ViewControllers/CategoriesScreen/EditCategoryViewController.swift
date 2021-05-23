//
//  EditCategoryViewController.swift
//  SaveMoney
//
//  Created by Alim on 09.05.2021.
//

import UIKit

class EditCategoryViewController: UIViewController {

    @IBOutlet weak var pageTitle: UILabel!
    @IBOutlet weak var categoryTitleField: UITextField!
    @IBOutlet weak var breadIcon: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var bottomView: UIView!
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var choosenIcon: UIButton!
    var delegate: UpdatePage!
    var currentCategory: Category!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewElements()
    }
    
    func setupViewElements() {
        bottomView.layer.cornerRadius = 30
        categoryTitleField.layer.borderColor = UIColor.lightGray.cgColor
        categoryTitleField.layer.borderWidth = 1
        categoryTitleField.layer.cornerRadius = 15
        categoryTitleField.layer.masksToBounds = true
        categoryTitleField.text = currentCategory.name
        
        cancelButton.layer.cornerRadius = 20
        saveButton.layer.cornerRadius = 20
        deleteButton.layer.cornerRadius = 20
    }

    @IBAction func categoryIconPressed(_ sender: UIButton) {
        choosenIcon.layer.backgroundColor = UIColor.white.cgColor
        sender.layer.cornerRadius = 20
        sender.layer.backgroundColor = UIColor.systemYellow.cgColor
        choosenIcon = sender
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        
        if categoryTitleField.text?.stringByRemovingWhitespaces != "" {
            currentCategory.name = categoryTitleField.text
            if choosenIcon != nil {
                currentCategory.iconPath = choosenIcon.accessibilityLabel
            }
            try! context.save()
            delegate.reloadData()
            self.dismiss(animated: true, completion: nil)
        } else {
            categoryTitleField.text? = ""
        }
    }
    
    @IBAction func deletePressed(_ sender: UIButton) {
        context.delete(currentCategory)
        try! context.save()
        delegate.reloadData()
        self.dismiss(animated: true, completion: nil)
    }
}
