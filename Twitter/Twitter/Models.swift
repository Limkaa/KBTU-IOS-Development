//
//  Models.swift
//  Twitter
//
//  Created by Alim on 14.04.2021.
//

import Foundation
import Firebase
import FirebaseDatabase

struct Profile {
    var name: String?
    var birthDate: String?
    var dict: [String: String] {
        return [
            "name": name!,
            "birthDate": birthDate!
        ]
    }
    
    init(_ name: String, birthDate: String) {
        self.name = name
        self.birthDate = birthDate
    }
    
    init(snapshot: DataSnapshot) {
        if let value = snapshot.value as? [String:String] {
            name = value["name"]
            birthDate = value["birthDate"]
        }
    }
}

struct Tweet {
    var date: String?
    var author: String?
    var author_uid: String?
    var content: String?
    var hashtags: String?
    var dict: [String: String] {
        return [
            "date": date!,
            "author": author!,
            "author_uid": author_uid!,
            "content": content!,
            "hashtags": hashtags!
        ]
    }
    
    init(_ date: String, author: String, author_uid: String, content: String, hashtags: String) {
        self.date = date
        self.author = author
        self.author_uid = author_uid
        self.content = content
        self.hashtags = hashtags
    }
    
    init(snapshot: DataSnapshot) {
        if let value = snapshot.value as? [String:String] {
            date = value["date"]
            author = value["author"]
            author_uid = value["author_uid"]
            content = value["content"]
            hashtags = value["hashtags"]
        }
    }
}
