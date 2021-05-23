//
//  AddTransferViewController.swift
//  SaveMoney
//
//  Created by Alim on 11.05.2021.
//

import UIKit

class AddTransferViewController: UIViewController {

    @IBOutlet weak var fromAccountButton: UIButton!
    @IBOutlet weak var toAccountButton: UIButton!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    var typing = false
    var fromAccountDropDownMenu = DropDownTableView()
    var toAccountDropDownMenu = DropDownTableView()
    var accounts: [Account]!
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
    }
    
    func setupViewElements() {
        bottomView.layer.cornerRadius = 30
        
        fromAccountButton.layer.cornerRadius = 15
        fromAccountButton.layer.masksToBounds = true
        
        toAccountButton.layer.cornerRadius = 15
        toAccountButton.layer.masksToBounds = true
        
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
    
    @IBAction func chooseToAccountPressed(_ sender: Any) {
        if accounts.count > 0 {
            toAccountDropDownMenu.viewForTransoarentView = self.view
            toAccountDropDownMenu.selectedButton = toAccountButton
            toAccountDropDownMenu.x = toAccountButton.frame.origin.x
            toAccountDropDownMenu.y = (toAccountButton.superview?.frame.origin.y)! + 160
            toAccountDropDownMenu.maxHeight = bottomView.frame.height - 160
            toAccountDropDownMenu.array = accounts
            toAccountDropDownMenu.fieldName = "title"
            toAccountDropDownMenu.width = toAccountButton.frame.width
            toAccountDropDownMenu.font = UIFont(name: "Helvetica", size: 20)
            toAccountDropDownMenu.addTransparentView()
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
        if fromAccountDropDownMenu.choosenObject == nil || toAccountDropDownMenu.choosenObject == nil || amountLabel.text!.stringByRemovingWhitespaces == "0" || (fromAccountDropDownMenu.choosenObject == toAccountDropDownMenu.choosenObject) {
            let alert = UIAlertController(title: "Warning", message: "Please check, that entered amount is greater than 0, accounts for transfer operation are chosen and they are not same!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
        else {
            let fromAccount = fromAccountDropDownMenu.choosenObject as! Account
            let toAccount = toAccountDropDownMenu.choosenObject as! Account
            let amount = Int32(amountLabel.text!.stringByRemovingWhitespaces)!
            
            let transaction = Transaction(context: context)
            transaction.amount = amount
            transaction.comment = (operationComment == "") ? nil : operationComment
            transaction.date = operationDate
            transaction.fromAccount = fromAccount
            transaction.toAccount = toAccount
            transaction.type = 3
            fromAccount.amount -= amount
            toAccount.amount += amount
            
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

extension AddTransferViewController: OperationDetailsSave {
    func saveDetails(date: Date, comment: String) {
        operationDate = date
        operationComment = comment
    }
}
