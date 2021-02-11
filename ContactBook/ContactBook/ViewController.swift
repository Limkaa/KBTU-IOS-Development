//
//  ViewController.swift
//  ContactBook
//
//  Created by Alim on 10.02.2021.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var myTableView: UITableView!
    var contactBook = ContactBook.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactBook.contacts.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell") as? CustomCell
        let currentContact = contactBook.contacts[indexPath.row]
        
        cell?.contactName.text = currentContact.name_surname
        cell?.contactPhone.text = currentContact.phone
        cell?.contactImage.image = currentContact.image
        
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = self.storyboard?.instantiateViewController(identifier: "DetailViewController") as! DetailViewController
        
        detailVC.myTable = myTableView
        detailVC.index = (myTableView?.indexPathForSelectedRow?.row)!
        detailVC.contactBook = contactBook
        
        navigationController?.pushViewController(detailVC, animated: true)
        myTableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    @IBAction func addContact(_ sender: UIBarButtonItem) {
        let detailVC = self.storyboard?.instantiateViewController(identifier: "AddContactViewController") as! AddContactViewController
        
        detailVC.myTable = myTableView
        detailVC.contactBook = contactBook
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

