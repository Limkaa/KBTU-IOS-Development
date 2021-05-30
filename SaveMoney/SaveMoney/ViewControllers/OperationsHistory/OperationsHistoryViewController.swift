//
//  OperationsHistoryViewController.swift
//  SaveMoney
//
//  Created by Alim on 11.05.2021.
//

import UIKit

class OperationsHistoryViewController: UIViewController {

    // ViewController elements (just design)
    @IBOutlet weak var operationsHistoryHeaderView: UIView!
    @IBOutlet weak var operationsHistoryListView: UIView!
    
    //ViewController elemts (design and content)
    @IBOutlet weak var operationsHistoryTableView: UITableView!
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var expenseLabel: UILabel!
    @IBOutlet weak var cashFlowLabel: UILabel!
    @IBOutlet weak var timePeriodButton: UIButton!
    @IBOutlet weak var previousPeriodButton: UIButton!
    @IBOutlet weak var nextPeriodButton: UIButton!
    @IBOutlet weak var timePeriodSegmentedControl: UISegmentedControl!
    
    // Necessary variables
    var operationsViewModel = OperationsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewElements()
    }

    override func viewDidAppear(_ animated: Bool) {
        self.reloadData()
    }
    
    // Configuration of elements in view
    func setupViewElements() {
        operationsHistoryListView.layer.cornerRadius = 30
        operationsHistoryHeaderView.layer.cornerRadius = 30
        operationsHistoryTableView.rowHeight = UITableView.automaticDimension
        operationsHistoryTableView.estimatedRowHeight = 600
        
        timePeriodButton.layer.cornerRadius = 20
        timePeriodTypeChanged(self)
        
        timePeriodSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: UIControl.State.selected)
        timePeriodSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.normal)
    }
    
    // Updaing information
    func reloadData() {
        timePeriodButton.setTitle(operationsViewModel.datesRange.toString(), for: .normal)
        operationsViewModel.getTransactions()
        incomeLabel.text = operationsViewModel.moneyRates.income.toString
        expenseLabel.text = operationsViewModel.moneyRates.expense.toString
        cashFlowLabel.text = operationsViewModel.moneyRates.cashFlow.toString
        operationsHistoryTableView.reloadData()
    }
    
    func setupTimePeriodButtons(period: Bool = false, previous: Bool = true, next: Bool = true) {
        previousPeriodButton.isHidden = !previous
        nextPeriodButton.isHidden = !next
        timePeriodButton.isEnabled = period
    }
    
    @IBAction func timePeriodTypeChanged(_ sender: Any) {
        let datesRange = operationsViewModel.datesRange
        let index = timePeriodSegmentedControl.selectedSegmentIndex
        switch index {
        case 0:
            setupTimePeriodButtons(previous: false, next: false)
            datesRange.setupDatesRange(type: .all)
        case 1, 2, 3, 4:
            setupTimePeriodButtons()
            datesRange.setupDatesRange(type: DateRangeType.init(rawValue: index)!)
        case 5:
            setupTimePeriodButtons(period: true, previous: false, next: false)
            datesRange.setupDatesRange(type: .custom)
        default:
            setupTimePeriodButtons(previous: false, next: false)
        }
        reloadData()
    }
    
    @IBAction func previousTimePeriodPressed(_ sender: Any) {
        operationsViewModel.datesRange.getAnotherPeriodByStep(step: -1)
        reloadData()
    }
    
    @IBAction func nextTimePeriodPressed(_ sender: Any) {
        operationsViewModel.datesRange.getAnotherPeriodByStep(step: 1)
        reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "chooseDatesRange":
            if let destination = segue.destination as? DatesRangePickerViewController {
                destination.delegate = self
                destination.datesRange = operationsViewModel.datesRange
            }
        case .none:
            return
        case .some(_):
            return
        }
    }
}


extension OperationsHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Configuration of the section header view
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeaderLabel = HeaderLabel()
        sectionHeaderLabel.text = (operationsViewModel.requestedTransactions[section].first!.date as Date?)?.dayString
        
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
        return operationsViewModel.requestedTransactions.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return operationsViewModel.requestedTransactions[section].count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "operationCell") as? OperationTableViewCell
        let allTransactions = operationsViewModel.requestedTransactions
        let transaction = TransactionViewModel(transaction: allTransactions[indexPath.section][indexPath.row])
        
        cell?.amount.text = transaction.amountString
        cell?.amount.textColor = transaction.typeColor
        cell?.comment.text = transaction.comment
        cell?.fromAccount.text = transaction.sourceTitle
        cell?.operationTitle.text = transaction.destinationTitle
        cell?.operationImage.image = transaction.icon
        cell?.transaction = transaction.instance
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            operationsViewModel.deleteOperation(indexPath: indexPath)
            reloadData()
        } else if editingStyle == .insert {
        }
    }
}

extension OperationsHistoryViewController: DateRangeSave {
    func saveDateRange(datesRange: DatesRange) {
        operationsViewModel.datesRange = datesRange
        reloadData()
    }
}
