//
//  LoginViewController.swift
//  Twitter
//
//  Created by Alim on 14.04.2021.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    var currentUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentUser = Auth.auth().currentUser
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        currentUser = Auth.auth().currentUser
        if currentUser != nil && currentUser!.isEmailVerified {
            gotoAccountPage()
        }
    }
    
    func setupView() {
        loginButton.layer.cornerRadius = 20
        registerButton.layer.cornerRadius = 20
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        let email = emailField.text
        let password = passwordField.text
        if email != "" && password != "" {
            loadingIndicator.startAnimating()
            Auth.auth().signIn(withEmail: email!, password: password!) { [weak self] (result, error) in
                self?.loadingIndicator.stopAnimating()
                if error == nil {
                    if Auth.auth().currentUser!.isEmailVerified {
                        self?.gotoAccountPage()
                    } else {
                        self?.showMessage(title: "Warning", message: "Your email is not verified")
                    }
                } else {
                    self?.showMessage(title: "Warning", message: "Email or password is incorrect")
                }
            }
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

    func gotoAccountPage() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let accountPage = storyboard.instantiateViewController(identifier: "TabController") as? TabBarController {
            accountPage.modalPresentationStyle = .fullScreen
            present(accountPage, animated: true, completion: nil)
        }
    }
    
}
