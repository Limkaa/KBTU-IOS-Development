//
//  StatisticsViewController.swift
//  SaveMoney
//
//  Created by Alim on 28.05.2021.
//

import UIKit
import CoreData

class StatisticsViewController: UIViewController {

    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var timePeriodButton: UIButton!
    @IBOutlet weak var previousPeriodButton: UIButton!
    @IBOutlet weak var nextPeriodButton: UIButton!
    @IBOutlet weak var timePeriodSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var incomeView: UIView!
    @IBOutlet weak var expenseView: UIView!
    @IBOutlet weak var cashFlowView: UIView!
    
    @IBOutlet weak var incomeTotal: UILabel!
    @IBOutlet weak var expenseTotal: UILabel!
    @IBOutlet weak var cashFlowTotal: UILabel!
    
    @IBOutlet weak var statisticsTableView: UITableView!
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var datesRange = DatesRange(type: .all)
    var rates = [Rates]()
    var totalRates = Rates()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewElements()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadData()
    }
    
    func setupViewElements() {
        bottomView.layer.cornerRadius = 30
        headerView.layer.cornerRadius = 30
        
        timePeriodButton.layer.cornerRadius = 20
        timePeriodTypeChanged(self)
        
        timePeriodSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: UIControl.State.selected)
        timePeriodSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.normal)
        
        incomeView.layer.cornerRadius = 20
        expenseView.layer.cornerRadius = 20
        cashFlowView.layer.cornerRadius = 20
        
        statisticsTableView.rowHeight = 50
    }
    
    func reloadData() {
        getTotalRates()
        getRates()
        statisticsTableView.reloadData()
        timePeriodButton.setTitle(datesRange.toString(), for: .normal)
    }
    
    func getRates() {
        rates = []
        let transactionRequest = Transaction.getTransactions(from: datesRange.from, till: datesRange.till)
        let transactions = Transaction.groupRequestedTransactions(transactions: try! context.fetch(transactionRequest), by: .month)
        
        for transactionGroup in transactions {
            let fromDate = transactionGroup[0].date?.startOfMonth
            let tillDate = transactionGroup[0].date?.endOfMonth
            let request = Transaction.getTransactions(from: fromDate!, till: tillDate!)
            let amounts = try! context.fetch(Transaction.getAmountOfTransactions(request: request))
            let incomeValue = Transaction.getAmount(result: amounts, type: .income)
            let expenseValue = Transaction.getAmount(result: amounts, type: .expense)
            
            if incomeValue != 0 || expenseValue != 0 {
                var rate = Rates()
                rate.income = Money(amount: incomeValue)
                rate.expense = Money(amount: expenseValue)
                rate.from = fromDate
                rate.till = tillDate
                rates.append(rate)
            }
        }
    }
    
    func getTotalRates() {
        let request = Transaction.getTransactions(from: datesRange.from, till: datesRange.till)
        let amounts = try! context.fetch(Transaction.getAmountOfTransactions(request: request))
        totalRates.income.amount = Transaction.getAmount(result: amounts, type: .income)
        totalRates.expense.amount = Transaction.getAmount(result: amounts, type: .expense)
        
        incomeTotal.text = totalRates.income.toString
        expenseTotal.text = totalRates.expense.toString
        cashFlowTotal.text = totalRates.cashFlow.toString
    }
    
    func setupTimePeriodButtons(period: Bool = false, previous: Bool = true, next: Bool = true) {
        previousPeriodButton.isHidden = !previous
        nextPeriodButton.isHidden = !next
        timePeriodButton.isEnabled = period
    }
    
    @IBAction func timePeriodTypeChanged(_ sender: Any) {
        let index = timePeriodSegmentedControl.selectedSegmentIndex
        switch index {
        case 0:
            setupTimePeriodButtons(previous: false, next: false)
            datesRange.setupDatesRange(type: .all)
        case 1:
            setupTimePeriodButtons()
            datesRange.setupDatesRange(type: .year)
        default:
            setupTimePeriodButtons(previous: false, next: false)
        }
        reloadData()
    }
    
    @IBAction func previousTimePeriodPressed(_ sender: Any) {
        datesRange.getAnotherPeriodByStep(step: -1)
        reloadData()
    }
    
    @IBAction func nextTimePeriodPressed(_ sender: Any) {
        datesRange.getAnotherPeriodByStep(step: 1)
        reloadData()
    }
}



extension StatisticsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rates.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        statisticsTableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "statisticCell") as? StatisticsTableViewCell
        let rate = rates[indexPath.row]
        
        cell?.incomeValue.text = rate.income.toString
        cell?.expenseValue.text = rate.expense.toString
        cell?.cashFlowValue.text = rate.cashFlow.toString
        cell?.date.text = rate.till!.monthShortString
        
        cell?.cashFlowValue.layer.cornerRadius = 10
        if (rate.cashFlow.amount > 0) {
            cell?.cashFlowValue.layer.backgroundColor = UIColor.init(red: 0, green: 1.0, blue: 0, alpha: 0.4).cgColor
        }
        else if (rate.cashFlow.amount < 0) {
            cell?.cashFlowValue.layer.backgroundColor = UIColor.init(red: 1.0, green: 0, blue: 0, alpha: 0.4).cgColor
        }
        else {
            cell?.cashFlowValue.layer.backgroundColor = UIColor.systemGray6.cgColor
        }
        
        cell?.transform = CGAffineTransform(translationX: -tableView.bounds.width, y: 0)
        UIView.animate(
            withDuration: 0.5,
            delay: 0.3 * Double(indexPath.row),
            options: .curveEaseInOut,
            animations: {
                cell?.transform = CGAffineTransform(translationX: 0, y: 0)
        })
        
        return cell!
    }
}
