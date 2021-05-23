//
//  AddCategoryViewController.swift
//  SaveMoney
//
//  Created by Alim on 09.05.2021.
//

import UIKit

class AddCategoryViewController: UIViewController {
    
    @IBOutlet weak var pageTitle: UILabel!
    @IBOutlet weak var categoryTitleField: UITextField!
    @IBOutlet weak var breadIcon: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var bottomView: UIView!
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var choosenIcon: UIButton!
    var delegate: UpdatePage!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewElements()
    }
    
    func setupViewElements() {
        choosenIcon = breadIcon
        bottomView.layer.cornerRadius = 30
        categoryTitleField.layer.borderColor = UIColor.lightGray.cgColor
        categoryTitleField.layer.borderWidth = 1
        categoryTitleField.layer.cornerRadius = 15
        categoryTitleField.layer.masksToBounds = true
        
        cancelButton.layer.cornerRadius = 20
        addButton.layer.cornerRadius = 20
        categoryIconPressed(choosenIcon)
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
    
    @IBAction func addPressed(_ sender: UIButton) {
        
        if categoryTitleField.text?.stringByRemovingWhitespaces != "" {
            let newCategory = Category(context: context)
            newCategory.name = categoryTitleField.text
            newCategory.iconPath = choosenIcon.accessibilityLabel
            
            try! context.save()
            delegate.reloadData()
            self.dismiss(animated: true, completion: nil)
        } else {
            categoryTitleField.text? = ""
        }
    }
}
