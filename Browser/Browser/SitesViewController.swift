//
//  SitesViewController.swift
//  Browser
//
//  Created by Alim on 25.02.2021.
//

import UIKit
import WebKit

var websitesList = WebsitesList(sites:[])


class SitesViewController: UITableViewController {
    
    @IBOutlet weak var viewMode: UISegmentedControl!
    var favouriteViewMode: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh),
                                               name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
    }
    
    @objc func refresh() {
        self.tableView.reloadData()
    }
    
    @IBAction func indexChanged(_ sender: Any!) {
        switch viewMode.selectedSegmentIndex {
        case 0:
            favouriteViewMode = false
        case 1:
            favouriteViewMode = true
        default:
            break
        }
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return websitesList.getSites(favouriteViewMode).count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        cell.textLabel?.text = websitesList.getSites(favouriteViewMode)[indexPath.row].name
        return cell
    }
      
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSite" {
            if let navcon = segue.destination as? UINavigationController {
                if let destination = navcon.visibleViewController as? InfoViewController {
                    if let row = tableView.indexPathForSelectedRow?.row {
                        let sites = websitesList.getSites(favouriteViewMode)
                        destination.website = sites[row]
                        destination.tableView = tableView
                        destination.navigationItem.title = sites[row].name
                    }
                }
            }
        }
    }
    

}
