//
//  AllTweetsViewController.swift
//  Twitter
//
//  Created by Alim on 15.04.2021.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class AllTweetsViewController: UIViewController, UITabBarDelegate, UITableViewDataSource {

    @IBOutlet weak var searchLine: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var tweets: [Tweet] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600

        let parent = Database.database().reference().child("tweets")
        parent.observe(.value) { [self] (snapshot) in
            self.tweets.removeAll()
            for child in snapshot.children {
                if let snap = child as? DataSnapshot {
                    let tweet = Tweet(snapshot: snap)
                    self.tweets.append(tweet)
                }
            }
            self.tweets.reverse()
            self.tableView.reloadData()
        }
    }
    
    func setupView() {
        searchLine.layer.cornerRadius = 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "personalTweetCell", for: indexPath) as? PersonalTweetTableViewCell
        
        let reference = Storage.storage().reference().child("images/\(tweets[indexPath.row].author_uid!).jpg")
        let placeholder: UIImage = UIImage.init(systemName: "person.circle")!
        cell?.userPhoto.sd_setImage(with: reference, placeholderImage: placeholder)
        cell?.userPhoto.layer.cornerRadius = 20
        
        cell?.bottomView.layer.cornerRadius = 20
        cell?.emailField.text = tweets[indexPath.row].author
        cell?.dateField.text = tweets[indexPath.row].date
        cell?.textField.text = tweets[indexPath.row].content
        cell?.hashtagsField.text = tweets[indexPath.row].hashtags
        
        return cell!
    }
    
    @IBAction func searchPressed(_ sender: UIBarButtonItem) {
        let keywords = searchLine.text
        let parent = Database.database().reference().child("tweets")
        parent.observe(.value) { [self] (snapshot) in
            self.tweets.removeAll()
            for child in snapshot.children {
                if let snap = child as? DataSnapshot {
                    let tweet = Tweet(snapshot: snap)
                    let hashtags = tweet.hashtags!
                    if hashtags.contains(keywords!) {
                        self.tweets.append(tweet)
                    }
                    if keywords == "" {
                        self.tweets.append(tweet)
                    }
                }
            }
            self.tweets.reverse()
            self.tableView.reloadData()
        }
    }
}
