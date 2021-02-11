//
//  DetailViewController.swift
//  ContactBook
//
//  Created by Alim on 11.02.2021.
//

import UIKit

class DetailViewController: UIViewController {
    
    var myTable: UITableView!
    var contactBook: ContactBook!
    var index: Int?

    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var contactName: UILabel!
    @IBOutlet weak var contactPhone: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentContact = contactBook.contacts[index!]
        contactName.text = currentContact.name_surname
        contactPhone.text = currentContact.phone
        contactImage.image = currentContact.image
    }
    
    
    @IBAction func deletePressed(_ sender: UIButton) {
        contactBook.deleteContact(index!)
        myTable.reloadData()
        navigationController?.popViewController(animated: true)
    }
}
