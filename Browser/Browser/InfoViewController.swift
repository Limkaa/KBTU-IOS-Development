//
//  InfoViewController.swift
//  Browser
//
//  Created by Alim on 25.02.2021.
//

import UIKit
import WebKit

class InfoViewController: UIViewController {
  
    @IBOutlet weak var webPage: WKWebView!
    var website: Site?
    var tableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = website?.url {
            let request = URLRequest(url: URL(string: url)!)
            webPage.load(request)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector (tripleTap))
        tapGesture.numberOfTapsRequired = 3
        webPage.addGestureRecognizer(tapGesture)
        
        setNavigationBarColor()
    }
    
    @objc func tripleTap() {
        if website != nil {
            websitesList.changeSiteStatus(website: website!)
            tableView?.reloadData()
            setNavigationBarColor()
        }
    }
    
    func setNavigationBarColor() {
        if website != nil {
            if websitesList.sites[(website?.siteIndex!)!].favourite {
                navigationController?.navigationBar.barTintColor = UIColor.yellow
            } else {
                navigationController?.navigationBar.barTintColor = nil
            }
        }
    }
    
    

   

}
