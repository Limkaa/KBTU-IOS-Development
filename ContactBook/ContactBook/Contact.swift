//
//  Contact.swift
//  ContactBook
//
//  Created by Alim on 10.02.2021.
//

import Foundation
import UIKit

class Contact {
    var name_surname: String?
    var phone: String?
    var gender: String?
    var image: UIImage?
    
    init(_ name_surname: String, _ phone: String, _ gender: String) {
        self.name_surname = name_surname
        self.phone = phone
        self.gender = gender
        switch gender {
        case "male":
            self.image = UIImage.init(named: "male")!
        case "female":
            self.image = UIImage.init(named: "female")!
        default:
            break
        }
    }
}
