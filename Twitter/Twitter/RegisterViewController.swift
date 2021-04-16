//
//  RegisterViewController.swift
//  Twitter
//
//  Created by Alim on 14.04.2021.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class RegisterViewController: UIViewController {

    var birthDate = ""
    @IBOutlet weak var nameSurnameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        registerButton.layer.cornerRadius = 20
    }
    
    @IBAction func datePickerChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY"
        birthDate = dateFormatter.string(from: sender.date)
    }

    
    @IBAction func registerPressed(_ sender: UIButton) {
        let email = emailField.text
        let password = passwordField.text
        let name = nameSurnameField.text
        
        if birthDate != "" && email != "" && password != "" && name != "" {
            loadingIndicator.startAnimating()
            Auth.auth().createUser(withEmail: email!, password: password!, completion: { [weak self]
                (result, error) in
                self?.loadingIndicator.stopAnimating()
                Auth.auth().currentUser?.sendEmailVerification(completion: nil)
                if error == nil {
                    self?.showMessage(title: "Success", message: "Please verify your email")
                    let profile = Profile(name!, birthDate: (self?.birthDate)!)
                    Database.database().reference().child("profiles").child(Auth.auth().currentUser!.uid).setValue(profile.dict)
                } else {
                    self?.showMessage(title: "Error", message: "Some preoblem occured")
                }
            })
        }
    }
    

    func showMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let ok = UIAlertAction(title: "OK", style: .default) { (UIAlertaction) in
            if title != "Error" {
                self.dismiss(animated: true, completion: nil)
            }
        }
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }

}
