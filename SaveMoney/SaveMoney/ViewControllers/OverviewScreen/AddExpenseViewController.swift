//
//  AddExpenseViewController.swift
//  SaveMoney
//
//  Created by Alim on 11.05.2021.
//

import UIKit

class AddExpenseViewController: UIViewController {

    @IBOutlet weak var fromAccountButton: UIButton!
    @IBOutlet weak var toCategoryButton: UIButton!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    var typing = false
    var fromAccountDropDownMenu = DropDownTableView()
    var toCategoryDropDownMenu = DropDownTableView()
    var accounts: [Account]!
    var categories: [Category]!
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var operationDate = Date()
    var operationComment = ""
    var delegate: UpdatePage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewElements()
        reloadData()
    }
    
    func reloadData() {
        self.accounts = try! context.fetch(Account.fetchRequest())
        self.categories = try! context.fetch(Category.fetchRequest())
    }
    
    func setupViewElements() {
        bottomView.layer.cornerRadius = 30
        
        fromAccountButton.layer.cornerRadius = 15
        fromAccountButton.layer.masksToBounds = true
        
        toCategoryButton.layer.cornerRadius = 15
        toCategoryButton.layer.masksToBounds = true
        
        amountLabel.layer.borderColor = UIColor.lightGray.cgColor
        amountLabel.layer.borderWidth = 1
        amountLabel.layer.cornerRadius = 15
        
        cancelButton.layer.cornerRadius = 20
        addButton.layer.cornerRadius = 20
    }

    @IBAction func chooseFromAccountPressed(_ sender: Any) {
        if accounts.count > 0 {
            fromAccountDropDownMenu.viewForTransoarentView = self.view
            fromAccountDropDownMenu.selectedButton = fromAccountButton
            fromAccountDropDownMenu.x = fromAccountButton.frame.origin.x
            fromAccountDropDownMenu.y = (fromAccountButton.superview?.frame.origin.y)! + 90
            fromAccountDropDownMenu.maxHeight = bottomView.frame.height - 100
            fromAccountDropDownMenu.array = accounts
            fromAccountDropDownMenu.fieldName = "title"
            fromAccountDropDownMenu.width = fromAccountButton.frame.width
            fromAccountDropDownMenu.font = UIFont(name: "Helvetica", size: 20)
            fromAccountDropDownMenu.addTransparentView()
        } else {
            let alert = UIAlertController(title: "Warning", message: "There are no any options to choose. You need to add new account!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    @IBAction func chooseToCategoryPressed(_ sender: Any) {
        if accounts.count > 0 {
            toCategoryDropDownMenu.viewForTransoarentView = self.view
            toCategoryDropDownMenu.selectedButton = toCategoryButton
            toCategoryDropDownMenu.x = toCategoryButton.frame.origin.x
            toCategoryDropDownMenu.y = (toCategoryButton.superview?.frame.origin.y)! + 160
            toCategoryDropDownMenu.maxHeight = bottomView.frame.height - 160
            toCategoryDropDownMenu.array = categories
            toCategoryDropDownMenu.fieldName = "name"
            toCategoryDropDownMenu.width = toCategoryButton.frame.width
            toCategoryDropDownMenu.font = UIFont(name: "Helvetica", size: 20)
            toCategoryDropDownMenu.addTransparentView()
        } else {
            let alert = UIAlertController(title: "Warning", message: "There are no any options to choose. You need to add new account!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    @IBAction func keyboardButtonPressed(_ sender: UIButton) {
        let current_symbol = sender.currentTitle!
        let current_display = amountLabel.text!
        
        if typing{
            if (current_symbol == "<") {
                if (amountLabel.text!.count == 1) {
                    amountLabel.text = "0"
                    typing = false
                }
                else {
                    var numberString = current_display.stringByRemovingWhitespaces
                    numberString.remove(at: numberString.index(before: numberString.endIndex))
                    amountLabel.text = Int(numberString)?.formattedWithSeparator
                }
            } else {
                if (current_display.count < 11) {
                    let numberString = current_display.stringByRemovingWhitespaces
                    amountLabel.text = Int(numberString + current_symbol)?.formattedWithSeparator
                }
            }
        }
        else {
            if (current_symbol != "0" && current_symbol != "<") {
                amountLabel.text = current_symbol
                typing = true
            }
        }
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addPressed(_ sender: UIButton) {
        if fromAccountDropDownMenu.choosenObject == nil || toCategoryDropDownMenu.choosenObject == nil || amountLabel.text!.stringByRemovingWhitespaces == "0" {
            let alert = UIAlertController(title: "Warning", message: "Please check, that entered amount is greater than 0, account and category for expense operation are chosen!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
        else {
            let fromAccount = fromAccountDropDownMenu.choosenObject as? Account
            let amount = Int32(amountLabel.text!.stringByRemovingWhitespaces)!
            
            let transaction = Transaction(context: context)
            transaction.amount = amount
            transaction.comment = (operationComment == "") ? nil : operationComment
            transaction.date = operationDate
            transaction.fromAccount = fromAccount
            transaction.toCategory = toCategoryDropDownMenu.choosenObject as? Category
            transaction.type = 2
            fromAccount?.amount -= amount
            
            try! context.save()
            delegate?.reloadData()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "addDetails":
            if let destination = segue.destination as? AddDetailsViewController {
                destination.delegate = self
                destination.currentDate = operationDate
                destination.currentText = operationComment
            }
        case .none:
            return
        case .some(_):
            return
        }
    }
    
}

extension AddExpenseViewController: OperationDetailsSave {
    func saveDetails(date: Date, comment: String) {
        operationDate = date
        operationComment = comment
    }
}
