//
//  AddViewController.swift
//  Browser
//
//  Created by Alim on 26.02.2021.
//

import UIKit

class AddViewController: UIViewController {

    @IBOutlet weak var websiteName: UITextField!
    @IBOutlet weak var websiteURL: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func pressedAddWebsite(_ sender: UIButton) {
        if !websiteName.text!.isEmpty && !websiteURL.text!.isEmpty {
            websitesList.sites.append(Site(siteIndex: websitesList.sites.count,
                                           name: websiteName.text!,
                                           favourite: false,
                                           url: websiteURL.text!))
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
        }
    }

}
