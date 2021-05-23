//
//  MainViewController.swift
//  SaveMoney
//
//  Created by Alim on 21.04.2021.
//

import UIKit

class MainViewController: UIViewController, UpdatePage {
    
    // View elements (just design)
    @IBOutlet weak var incomeView: UIView!
    @IBOutlet weak var expenseView: UIView!
    @IBOutlet weak var exchangeRatesView: UIView!
    @IBOutlet weak var accountsView: UIView!
    @IBOutlet weak var accountsHeaderView: UIView!
    @IBOutlet weak var newTransferButton: UIButton!
    @IBOutlet weak var newIncomeButton: UIButton!
    @IBOutlet weak var newExpenseButton: UIButton!
    
    // View elements (design and content)
    @IBOutlet weak var balanceTotalValue: UILabel!
    @IBOutlet weak var incomeTitle: UILabel!
    @IBOutlet weak var incomeValue: UILabel!
    @IBOutlet weak var expenseTitle: UILabel!
    @IBOutlet weak var expenseValue: UILabel!
    @IBOutlet weak var exchangeValueUSD: UILabel!
    @IBOutlet weak var exchangeValueEUR: UILabel!
    @IBOutlet weak var exchangeValueRUB: UILabel!
    @IBOutlet weak var accountsHeaderTitle: UILabel!
    @IBOutlet weak var accountsTable: UITableView!
    @IBOutlet weak var newOperationTitle: UILabel!
    
    // Necessary variables
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var accounts: [Account] = []
    var datesRange = DatesRange(type: .month)
    var currenciesAPI = ExchangeRatesAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewElements()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        reloadData()
    }
    
    func setupViewElements() {
        view.layoutSubviews()
        incomeView.layer.cornerRadius = 20
        expenseView.layer.cornerRadius = 20
        exchangeRatesView.layer.cornerRadius = 30
        accountsView.layer.cornerRadius = 30
        accountsHeaderView.layer.cornerRadius = 30
        newTransferButton.layer.cornerRadius = 20
        newIncomeButton.layer.cornerRadius = 20
        newExpenseButton.layer.cornerRadius = 20
    }
    
   

    func requestCurrenciesAPI() {
        guard let url = URL(string: "https://v6.exchangerate-api.com/v6/9edc345fe97bb51a40ddd1d4/latest/KZT") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil { return }
            guard let safeData = data else { return }
            
            do {
                let results = try JSONDecoder().decode(ExchangeRates.self, from: safeData)
                let rates = results.conversion_rates
                DispatchQueue.main.async {
                    self.exchangeValueUSD.text = String(format: "%.2f", 1/rates["USD"]!)
                    self.exchangeValueRUB.text = String(format: "%.2f", 1/rates["RUB"]!)
                    self.exchangeValueEUR.text = String(format: "%.2f", 1/rates["EUR"]!)
                }
            } catch {
                
            }
        }
    }
    
    
    func reloadData() {
        self.accounts = try! context.fetch(Account.fetchRequest())
        let request = Transaction.getTransactions(from: datesRange.from, till: datesRange.till)
        let amounts = try! context.fetch(Transaction.getAmountOfTransactions(request: request))
        let balance = try! context.fetch(Account.getBalanceOfAccounts(request: Account.fetchRequest()))
        incomeValue.text = Transaction.getAmount(result: amounts, type: .income).formattedWithSeparator
        expenseValue.text = Transaction.getAmount(result: amounts, type: .expense).formattedWithSeparator
        balanceTotalValue.text = Account.getAmount(result: balance).formattedWithSeparator
        requestCurrenciesAPI()
        accountsTable.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "addAccount":
            if let destination = segue.destination as? AddAccountViewController {
                destination.delegate = self
            }
        case "editAccount":
            if let destination = segue.destination as? EditAccountViewController {
                destination.delegate = self
                let currentRow = accountsTable.indexPathForSelectedRow?.row
                destination.currentAccount = accounts[currentRow!]
            }
        case "addIncome":
            if let destination = segue.destination as? AddIncomeViewController {
                destination.delegate = self
            }
        case "addTransfer":
            if let destination = segue.destination as? AddTransferViewController {
                destination.delegate = self
            }
        case "addExpense":
            if let destination = segue.destination as? AddExpenseViewController {
                destination.delegate = self
            }
        case .none:
            return
        case .some(_):
            return
        }
    }
}


extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        accountsTable.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountCell") as? AccountTableViewCell
        let currentAccount = accounts[indexPath.row]

        cell?.bottomView.layer.cornerRadius = 15
        cell?.title.text = currentAccount.title
        cell?.balance.text = "Balance: \(currentAccount.amount.formattedWithSeparator)"
        cell?.imageType.image = UIImage.init(named: currentAccount.type!)
        cell?.tag = indexPath.row
        
        return cell!
    }
}
