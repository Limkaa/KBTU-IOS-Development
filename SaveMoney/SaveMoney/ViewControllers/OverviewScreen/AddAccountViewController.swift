//
//  AddAccountViewController.swift
//  SaveMoney
//
//  Created by Alim on 21.04.2021.
//

import UIKit

class AddAccountViewController: UIViewController {
    
    // View elements (just design)
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var walletButton: UIButton!
    @IBOutlet weak var cardButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    // View elements (design and values)
    @IBOutlet weak var pageTitle: UILabel!
    @IBOutlet weak var accountTitleField: UITextField!
    @IBOutlet weak var balanceAmount: UILabel!
    
    // Other variables
    var typing = false
    var choosenAccountType = "wallet"
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var delegate: UpdatePage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewElements()
    }
    
    func setupViewElements() {
        bottomView.layer.cornerRadius = 30
        accountTitleField.layer.borderColor = UIColor.lightGray.cgColor
        accountTitleField.layer.borderWidth = 1
        accountTitleField.layer.cornerRadius = 15
        accountTitleField.layer.masksToBounds = true
        
        balanceAmount.layer.borderColor = UIColor.lightGray.cgColor
        balanceAmount.layer.borderWidth = 1
        balanceAmount.layer.cornerRadius = 15
        
        walletButton.layer.cornerRadius = 10
        cardButton.layer.cornerRadius = 10
        
        cancelButton.layer.cornerRadius = 20
        addButton.layer.cornerRadius = 20
    }
    
    @IBAction func walletPressed(_ sender: UIButton) {
        walletButton.layer.backgroundColor = UIColor.systemYellow.cgColor
        cardButton.layer.backgroundColor = UIColor.white.cgColor
        choosenAccountType = "wallet"
    }
    
    @IBAction func cardPressed(_ sender: UIButton) {
        walletButton.layer.backgroundColor = UIColor.white.cgColor
        cardButton.layer.backgroundColor = UIColor.systemYellow.cgColor
        choosenAccountType = "debit-card"
    }
    
    @IBAction func keyboardButtonPressed(_ sender: UIButton) {
        let current_symbol = sender.currentTitle!
        let current_display = balanceAmount.text!
        
        if typing{
            if (current_symbol == "<") {
                if (balanceAmount.text!.count == 1) {
                    balanceAmount.text = "0"
                    typing = false
                }
                else {
                    var numberString = current_display.stringByRemovingWhitespaces
                    numberString.remove(at: numberString.index(before: numberString.endIndex))
                    balanceAmount.text = Int(numberString)?.formattedWithSeparator
                }
            } else {
                if (current_display.count < 11) {
                    let numberString = current_display.stringByRemovingWhitespaces
                    balanceAmount.text = Int(numberString + current_symbol)?.formattedWithSeparator
                }
            }
        }
        else {
            if (current_symbol != "0" && current_symbol != "<") {
                balanceAmount.text = current_symbol
                typing = true
            }
        }
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addPressed(_ sender: UIButton) {
        
        if accountTitleField.text?.stringByRemovingWhitespaces != "" {
            let newAccount = Account(context: context)
            newAccount.title = accountTitleField.text
            newAccount.type = choosenAccountType
            newAccount.amount = Int32(balanceAmount.text!.stringByRemovingWhitespaces)!
            
            try! context.save()
            delegate?.reloadData()
            self.dismiss(animated: true, completion: nil)
        } else {
            accountTitleField.text? = ""
        }
    }
}
