//
//  RetrieveContactsViewController.swift
//  RetrieveContacts
//
//  Created by Chrishon Wyllie on 1/18/17.
//  Copyright © 2017 Chrishon Wyllie. All rights reserved.
//

import UIKit
import Contacts

class RetrieveContactsViewController: UIViewController {
    
    
    /*
     
     Dont forget to add "NSContactsUsageDescription" to your Info.plist file. Failing to do so before running 
     this project will simply result in a crash but the console at the bottom will tell you to do this.
     
     
     All this does is provide the common popup window asking users if this app can have access to their phone book.
     
     */
    

    var objects = [CNContact]()
    var selectedContactPhoneNumbers = [String]()
    var selectedContactUserIds = [String]()
    
    final fileprivate let contactsToAddReuseIdentifier = "addContactCell"
    final fileprivate let contactsToInviteReuseIdentifer = "inviteContactCell"
    
    lazy var contactsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    func setupUIElements() {
        self.view.addSubview(contactsTableView)
        
        contactsTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        contactsTableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        contactsTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        contactsTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUIElements()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        contactsTableView.delegate = self
        contactsTableView.dataSource = self
        contactsTableView.register(UITableViewCell.self, forCellReuseIdentifier: contactsToAddReuseIdentifier)
        contactsTableView.register(ContactCell.self, forCellReuseIdentifier: contactsToInviteReuseIdentifer)
        //getContacts()
        findContactsOnBackgroundThread { (contacts) in
            self.objects = contacts!
            self.contactsTableView.reloadData()
        }
    }
    
    // Due to your phone book possibly having hundreds of numbers, your contacts are retrieved on the background thread in order to avoid holding up the view. 
    
    // A completion block is used to pass the results of the query as an array. in the ViewDidLoad function you will notice that the result of this completion block
    
    func findContactsOnBackgroundThread (_ completionHandler: @escaping (_ contacts:[CNContact]?)->()) {
        
        DispatchQueue.global(qos: .userInitiated).async(execute: { () -> Void in
            
            let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactPhoneNumbersKey] as [Any] //CNContactIdentifierKey
            let fetchRequest = CNContactFetchRequest( keysToFetch: keysToFetch as! [CNKeyDescriptor])
            var contacts = [CNContact]()
            CNContact.localizedString(forKey: CNLabelPhoneNumberiPhone)
            
            if #available(iOS 10.0, *) {
                fetchRequest.mutableObjects = false
            } else {
                // Fallback on earlier versions
            }
            fetchRequest.unifyResults = true
            fetchRequest.sortOrder = .userDefault
            
            let contactStoreID = CNContactStore().defaultContainerIdentifier()
            
            do {
                
                try CNContactStore().enumerateContacts(with: fetchRequest) { (contact, stop) -> Void in
                    //do something with contact
                    if contact.phoneNumbers.count > 0 {
                        contacts.append(contact)
                    }
                    
                }
            } catch let e as NSError {
                print(e.localizedDescription)
            }
            
            DispatchQueue.main.async(execute: { () -> Void in
                completionHandler(contacts)
                
            })
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension RetrieveContactsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int { return 2 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 7
        } else { return objects.count }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let addContactsCell: UITableViewCell!
        let inviteContactsCell: ContactCell!
        if indexPath.section == 0 {
            addContactsCell = tableView.dequeueReusableCell(withIdentifier: contactsToAddReuseIdentifier, for: indexPath)
            addContactsCell.textLabel?.text = "test"
            return addContactsCell
        } else {
            inviteContactsCell = tableView.dequeueReusableCell(withIdentifier: contactsToInviteReuseIdentifer, for: indexPath) as! ContactCell
            
            let contact = self.objects[indexPath.row]
            
            configureCell(inviteContactsCell, contact: contact)
            return inviteContactsCell
        }
    }
    
    func configureCell(_ cell: ContactCell, contact: CNContact) {
        
        let formatter = CNContactFormatter()
        
        var contactPhoneNumber = (contact.phoneNumbers[0].value).value(forKey: "digits") as? String
        
        // Sometimes people in your phone book may have a +1 (The country code. in this case, this is the United States code) in their phone number which may or may not hinder your app's use, to get around that, here is a simple way to remove that +1
        
        if (contactPhoneNumber?.contains("+1"))! {
            
            print("\(formatter.string(from: contact))'s phoneNumber contains a +1: \(contactPhoneNumber)")
            let index = contactPhoneNumber?.index((contactPhoneNumber?.startIndex)!, offsetBy: 2)
            contactPhoneNumber = contactPhoneNumber?.substring(from: index!)
            
        }
        cell.contactNameLabel.text = formatter.string(from: contact)
    }
}
