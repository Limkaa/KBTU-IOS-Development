//
//  SettingsViewController.swift
//  SaveMoney
//
//  Created by Alim on 28.05.2021.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var sendMessageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewElements()
    }
    
    func setupViewElements() {
        bottomView.layer.cornerRadius = 30
        
        textView.text = ""
        textView.layer.borderColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 15
        textView.layer.masksToBounds = true
        
        sendMessageButton.layer.cornerRadius = 20
    }
    
    @IBAction func sendMessagePressed(_ sender: Any) {
        if textView.text != "" {
            let urlString = "https://tenderwin.gdh.kz/saveMoneyAppSupport.php?message=\(textView.text!)"
            guard let url = URL(string: urlString) else { return }
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in return }
            task.resume()
            textView.text = ""
            
            let alert = UIAlertController(title: "Successfully sent!".localized(), message: "Your message was successfully sent!".localized(), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
        
    }
    
    
}
