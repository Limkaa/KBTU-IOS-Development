//
//  EditAccountViewController.swift
//  Twitter
//
//  Created by Alim on 15.04.2021.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class EditAccountViewController: UIViewController {

    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    var profile: Profile?
    var currentUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentUser = Auth.auth().currentUser
        let profileObject = Database.database().reference().child("profiles").child(currentUser!.uid)
        profileObject.observe(.value) { [self] (snapshot) in
            self.profile = Profile(snapshot: snapshot)
            self.nameField.text = self.profile?.name
        }
        // Do any additional setup after loading the view.
    }
    
    func setupView() {
        saveButton.layer.cornerRadius = 20
    }
    
    @IBAction func closePressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        let name = nameField.text
        
        if name != "" {
            loadingIndicator.startAnimating()
            Database.database().reference().child("profiles").child(currentUser!.uid).setValue(["name": name, "birthDate": profile?.birthDate]) {
              (error:Error?, ref:DatabaseReference) in
              if error != nil {
                self.showMessage(title: "Error", message: "Some preoblem occured")
              } else {
                self.loadingIndicator.stopAnimating()
                self.dismiss(animated: true, completion: nil)
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

}
