//
//  ViewController.swift
//  Midterm
//
//  Created by Alim on 12.03.2021.
//

import UIKit

class Alarm {
    var time: String
    var note: String
    var switchStatus: Bool = true
    
    init(time: String, note: String) {
        self.time = time
        self.note = note
    }
}

class ViewController: UIViewController, AddAlarm, ChangeAlarm, DeleteAlarm, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var myTableView: UITableView!
    var myAlarms: Array<Alarm> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.delegate = self
        myTableView.dataSource = self
    }

    func addAlarm(time: String, note: String) {
        myAlarms.append(Alarm(time: time, note: note))
        myTableView.reloadData()
    }
    
    func changeAlarmInfo(time: String, note: String, index: Int) {
        myAlarms[index].time = time
        myAlarms[index].note = note
        myTableView.reloadData()
    }
    
    func deleteAlarm(index: Int) {
        myAlarms.remove(at: index)
        myTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myAlarms.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell") as? CustomCell
        let currentAlarm = myAlarms[indexPath.row]

        cell?.alarmTime.text = currentAlarm.time
        cell?.alarmNote.text = currentAlarm.note
        cell?.alarmSwicth.setOn(currentAlarm.switchStatus, animated: false)
        cell?.alarmSwicth.tag = indexPath.row
        
        return cell!
    }
    
    @IBAction func switchPressed(_ sender: UISwitch) {
        myAlarms[sender.tag].switchStatus = sender.isOn
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myTableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            myAlarms.remove(at: indexPath.row)
            tableView.reloadData()
        } else if editingStyle == .insert {
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "addNewAlarm":
            if let destination = segue.destination as? NewAlarmViewController {
                destination.delegate = self
            }
        case "changeAlarm":
            if let destination = segue.destination as? ChangeAlarmViewController {
                let currentRow = myTableView.indexPathForSelectedRow?.row
                destination.currentAlarm = myAlarms[currentRow!]
                destination.alarmIndex = currentRow!
                
                destination.delegate = self
            }
        case .none:
            return
        case .some(_):
            return
        }
    }
}

