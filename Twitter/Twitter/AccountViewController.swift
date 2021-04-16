//
//  AccountViewController.swift
//  Twitter
//
//  Created by Alim on 14.04.2021.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import FirebaseUI

class AccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var accountEditButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var userPhoto: UIImageView!
    @IBOutlet weak var birthDate: UILabel!
    @IBOutlet weak var changePhotoButton: UIButton!
    var profile: Profile?
    var tweets: [Tweet] = []
    var tweetsUID: [String] = []
    
    var currentUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        currentUser = Auth.auth().currentUser
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        
        let profileObject = Database.database().reference().child("profiles").child(currentUser!.uid)
        profileObject.observe(.value) { [self] (snapshot) in
            self.profile = Profile(snapshot: snapshot)
            self.birthDate.text = self.profile?.birthDate
            self.emailLabel.text = self.currentUser?.email
            self.nameLabel.text = self.profile?.name
        }

        let parent = Database.database().reference().child("tweets")
        parent.observe(.value) { [self] (snapshot) in
            self.tweets.removeAll()
            for child in snapshot.children {
                if let snap = child as? DataSnapshot {
                    let tweet = Tweet(snapshot: snap)
                    if tweet.author_uid == currentUser?.uid {
                        self.tweets.append(tweet)
                        let key = (child as AnyObject).key as String
                        self.tweetsUID.append(key)
                    }
                }
            }
            self.tweets.reverse()
            self.tweetsUID.reverse()
            self.tableView.reloadData()
        }
        
        updateProfileImage()
    }
    
    func setupView() {
        logoutButton.layer.cornerRadius = 10
        accountEditButton.layer.cornerRadius = 10
        searchField.layer.cornerRadius = 10
        userPhoto.contentMode = .scaleAspectFit
        userPhoto.layer.cornerRadius = 35
        changePhotoButton.layer.cornerRadius = 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "personalTweetCell", for: indexPath) as? PersonalTweetTableViewCell
        
        cell?.userPhoto.image = self.userPhoto.image
        cell?.userPhoto.layer.cornerRadius = 20
        cell?.bottomView.layer.cornerRadius = 20
        cell?.emailField.text = tweets[indexPath.row].author
        cell?.dateField.text = tweets[indexPath.row].date
        cell?.textField.text = tweets[indexPath.row].content
        cell?.hashtagsField.text = tweets[indexPath.row].hashtags
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let editingPage = storyboard.instantiateViewController(identifier: "EditTweetViewController") as? EditTweetViewController {
            editingPage.tweetUID = tweetsUID[indexPath.row]
            editingPage.modalPresentationStyle = .popover
            present(editingPage, animated: true, completion: nil)
        }
    }
    
    @IBAction func changePhotoPressed(_ sender: UIButton)  {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true, completion: nil)
    }
    
    func uploadProfileImage (_ image: UIImage, completion: @escaping ((_ url: URL?) -> ())) {
        let data = image.pngData()
        let storageRef = Storage.storage().reference().child("images/\(currentUser!.uid).jpg")
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        storageRef.putData(data!, metadata: metaData) { [self] (metadata, error) in
            Storage.storage().reference().child("images/\(self.currentUser!.uid).jpg").downloadURL { (url, error) in
                if let URL = url {
                    completion(URL)
                } else {
                    completion(nil)
                }
            }
        }
    }
    
    func updateProfileImage() {
        let reference = Storage.storage().reference().child("images/\(currentUser!.uid).jpg")
        let placeholder: UIImage = UIImage.init(systemName: "person.circle")!
        userPhoto.sd_setImage(with: reference, placeholderImage: placeholder)
        tableView.reloadData()
    }
    
    @IBAction func logoutPressed(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Something wrong")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createTweetPressed(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let addingPage = storyboard.instantiateViewController(identifier: "AddTweetViewController") as? AddTweetViewController {
            addingPage.modalPresentationStyle = .popover
            present(addingPage, animated: true, completion: nil)
        }
    }
    
    @IBAction func searchPressed(_ sender: UIBarButtonItem) {
        let keywords = searchField.text
        let parent = Database.database().reference().child("tweets")
        parent.observe(.value) { [self] (snapshot) in
            self.tweets.removeAll()
            for child in snapshot.children {
                if let snap = child as? DataSnapshot {
                    let tweet = Tweet(snapshot: snap)
                    let hashtags = tweet.hashtags!
                    if tweet.author_uid == currentUser?.uid && hashtags.contains(keywords!) {
                        self.tweets.append(tweet)
                        let key = (child as AnyObject).key as String
                        self.tweetsUID.append(key)
                    }
                    if keywords == "" && tweet.author_uid == currentUser?.uid {
                        self.tweets.append(tweet)
                        let key = (child as AnyObject).key as String
                        self.tweetsUID.append(key)
                    }
                }
            }
            self.tweets.reverse()
            self.tableView.reloadData()
        }
    }
}


extension AccountViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            userPhoto.image = image
            uploadProfileImage(image) { url in
                self.tableView.reloadData()
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
