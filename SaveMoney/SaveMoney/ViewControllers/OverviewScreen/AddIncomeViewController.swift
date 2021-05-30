//
//  AddIncomeViewController.swift
//  SaveMoney
//
//  Created by Alim on 10.05.2021.
//

import UIKit

class AddIncomeViewController: UIViewController {

    @IBOutlet weak var accountButton: UIButton!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    var typing = false
    var accountsDropDownMenu = DropDownTableView()
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
        accountButton.layer.cornerRadius = 15
        accountButton.layer.masksToBounds = true
        
        amountLabel.layer.borderColor = UIColor.lightGray.cgColor
        amountLabel.layer.borderWidth = 1
        amountLabel.layer.cornerRadius = 15
        
        cancelButton.layer.cornerRadius = 20
        addButton.layer.cornerRadius = 20
    }

    @IBAction func chooseAccountPressed(_ sender: Any) {
        if accounts.count > 0 {
            accountsDropDownMenu.viewForTransoarentView = self.view
            accountsDropDownMenu.selectedButton = accountButton
            accountsDropDownMenu.x = accountButton.frame.origin.x
            accountsDropDownMenu.y = (accountButton.superview?.frame.origin.y)! + 90
            accountsDropDownMenu.maxHeight = bottomView.frame.height - 100
            accountsDropDownMenu.array = accounts
            accountsDropDownMenu.fieldName = "title"
            accountsDropDownMenu.width = accountButton.frame.width
            accountsDropDownMenu.font = UIFont(name: "Helvetica", size: 20)
            accountsDropDownMenu.addTransparentView()
        } else {
            let alert = UIAlertController(title: "Warning".localized(), message: "There are no any options to choose. You need to add new account!".localized(), preferredStyle: .alert)
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
        if accountsDropDownMenu.choosenObject == nil || amountLabel.text!.stringByRemovingWhitespaces == "0" {
            let alert = UIAlertController(title: "Warning".localized(), message: "Please check, that entered amount is greater than 0 and account for income operation is chosen!".localized(), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
        else {
            let toAccount = accountsDropDownMenu.choosenObject as? Account
            let amount = Int32(amountLabel.text!.stringByRemovingWhitespaces)!
            
            let transaction = Transaction(context: context)
            transaction.amount = amount
            transaction.comment = (operationComment == "") ? nil : operationComment
            transaction.date = operationDate
            transaction.toAccount = toAccount
            transaction.type = 1
            toAccount?.amount += amount
            
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

extension AddIncomeViewController: OperationDetailsSave {
    func saveDetails(date: Date, comment: String) {
        operationDate = date
        operationComment = comment
    }
}
