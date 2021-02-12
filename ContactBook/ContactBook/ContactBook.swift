//
//  ContactBook.swift
//  ContactBook
//
//  Created by Alim on 11.02.2021.
//

import Foundation

class ContactBook {
    var contacts: Array<Contact> = []
    
    func addContact(_ newContact: Contact) {
        contacts.append(newContact)
    }
    
    func deleteContact(_ contactIndex: Int) {
        contacts.remove(at: contactIndex)
    }
    
}
