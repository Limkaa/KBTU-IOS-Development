//
//  CategoryOperationsViewController.swift
//  SaveMoney
//
//  Created by Alim on 09.05.2021.
//

import UIKit

class CategoryOperationsViewController: UIViewController {
    
    // ViewController elements (just design)
    @IBOutlet weak var operationsHistoryHeaderView: UIView!
    @IBOutlet weak var operationsHistoryListView: UIView!
    
    //ViewController elemts (design and content)
    @IBOutlet weak var operationsHistoryTableView: UITableView!
    @IBOutlet weak var categoryTitle: UILabel!
    @IBOutlet weak var expenseLabel: UILabel!
    @IBOutlet weak var timePeriodLabel: UILabel!
    
    // Necessary variables
    var category: Category!
    var datesRange: DatesRange!
    var transactions = [[Transaction]]()
    var expenseAmount: Int = 0
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewElements()
        reloadData()
    }

    // Configuration of elements in view
    func setupViewElements() {
        categoryTitle.text = category.name
        timePeriodLabel.text = datesRange.toString()
        operationsHistoryListView.layer.cornerRadius = 30
        operationsHistoryHeaderView.layer.cornerRadius = 30
        operationsHistoryTableView.rowHeight = UITableView.automaticDimension
        operationsHistoryTableView.estimatedRowHeight = 600
    }
    
    // Updaing information
    func reloadData() {
        let request = category.getTransactions(from: datesRange.from, till: datesRange.till)
        let requestedTransactions = try! context.fetch(request)
        self.transactions = Transaction.groupRequestedTransactions(transactions: requestedTransactions)
        
        let amountsRequest = Transaction.getAmountOfTransactions(request: request)
        let amounts = try! context.fetch(amountsRequest)
        expenseLabel.text = "- \(Transaction.getAmount(result: amounts, type: .expense).formattedWithSeparator)"
        
        operationsHistoryTableView.reloadData()
    }
    
    @IBAction func closePressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}


extension CategoryOperationsViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Configuration of the section header view
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeaderLabel = HeaderLabel()
        sectionHeaderLabel.text = (transactions[section].first!.date as Date?)?.dayString
        
        let containerView = UIView()
        containerView.addSubview(sectionHeaderLabel)
        sectionHeaderLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        sectionHeaderLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true

        return containerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        operationsHistoryTableView.deselectRow(at: indexPath, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions[section].count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "operationCell") as? OperationTableViewCell
        let transaction = TransactionViewModel(transaction: transactions[indexPath.section][indexPath.row])
        
        cell?.amount.text = transaction.amountString
        cell?.amount.textColor = transaction.typeColor
        cell?.comment.text = transaction.comment
        cell?.fromAccount.text = transaction.sourceTitle
        cell?.operationTitle.text = transaction.destinationTitle
        cell?.operationImage.image = transaction.icon
        cell?.transaction = transaction.instance
        print(transaction.amount)
        
        return cell!
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            transactions.deleteOperation(indexPath: indexPath)
//            reloadData()
//        } else if editingStyle == .insert {
//        }
//    }
}
