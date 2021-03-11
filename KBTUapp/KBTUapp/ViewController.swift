//
//  ViewController.swift
//  KBTUapp
//
//  Created by Alim on 05.03.2021.
//

import UIKit

class ViewController: UIViewController, ReservationShowable {
    
    @IBOutlet weak var ReservationField: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ReservationViewController {
            destination.delegate = self
        }
    }
    
    @IBAction func DeleteReservationPressed(_ sender: Any) {
        ReservationField.text = "You have no any reservation"
    }
    
    func showReservation(faculty: String, manager: String, time: String, name: String) {
        ReservationField.text = [faculty, manager, time, name].joined(separator: ", ")
    }
}

protocol ReservationShowable {
    func showReservation(faculty: String, manager: String, time: String, name: String)
}

