//
//  ViewController.swift
//  Animations
//
//  Created by Alim on 29.03.2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var loginTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextfields()
        setupButton()
    }
    
    func setupButton() {
        self.nextButton.alpha = 0
        UIView.animate(withDuration: 1.5) {
            self.nextButton.alpha = 1
        }
        nextButton.layer.borderColor = UIColor.white.cgColor
        nextButton.layer.borderWidth = 1
        nextButton.layer.cornerRadius = 5
    }
    
    func setupTextfields() {
        self.loginTextfield.center = CGPoint(x: -150, y: self.loginTextfield.frame.midY)
        self.passwordTextfield.center = CGPoint(x: self.view.bounds.width + 150, y: self.passwordTextfield.frame.midY)
        UIView.animate(withDuration: 1) {
            self.loginTextfield.center = CGPoint(x: self.view.bounds.width/2, y: self.loginTextfield.frame.midY)
            self.passwordTextfield.center = CGPoint(x: self.view.bounds.width/2, y: self.passwordTextfield.frame.midY)
        }
    }

    @IBAction func pressedNextButton(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2) {
            self.loginTextfield.center = CGPoint(x: -150, y: self.loginTextfield.frame.midY)
            self.passwordTextfield.center = CGPoint(x: self.view.bounds.width + 150, y: self.passwordTextfield.frame.midY)
        }
    }
    
}

