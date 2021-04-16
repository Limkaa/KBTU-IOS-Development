//
//  AddTweetViewController.swift
//  Twitter
//
//  Created by Alim on 16.04.2021.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class AddTweetViewController: UIViewController {

    
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var hashtagsField: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    var profile: Profile?
    var currentUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        currentUser = Auth.auth().currentUser
    }
    
    func setupView() {
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 1
        textField.layer.borderColor = CGColor.init(red: 0, green: 0, blue: 0, alpha: 1)
        hashtagsField.layer.cornerRadius = 10
        hashtagsField.layer.borderWidth = 1
        hashtagsField.layer.borderColor = CGColor.init(red: 0, green: 0, blue: 0, alpha: 1)
        saveButton.layer.cornerRadius = 15
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm, d MMM y"
        let date = formatter.string(from: today)
        var hashtags = hashtagsField!.text!
        if hashtags == "" {
            hashtags = "#tweet"
        }
        let tweet = Tweet((date), author: (self.currentUser?.email)!, author_uid: (self.currentUser?.uid)!, content: textField!.text!, hashtags: hashtags)
        Database.database().reference().child("tweets").childByAutoId().setValue(tweet.dict)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closePressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
