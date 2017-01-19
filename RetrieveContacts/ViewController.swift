//
//  ViewController.swift
//  RetrieveContacts
//
//  Created by Chrishon Wyllie on 1/18/17.
//  Copyright © 2017 Chrishon Wyllie. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    // Example of a programmatically created UIButton
    // The lazy declaration allows the button to access functions within this swift file
    
    lazy var button: UIButton = {
        let button = UIButton(type: .system)
        
        // allows you to set your own constraints. (Where it will appear on screen)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitle("Go To My Contacts", for: .normal)
        
        button.titleLabel?.textColor = UIColor.white
        
        button.backgroundColor = UIColor.red
        
        // makes the button rounded at the edges. The higher the number, the more rounded it will be
        button.layer.cornerRadius = 15
        
        button.addTarget(self, action: #selector(goToMyContactsViewController), for: .touchUpInside)
        
        return button
    }()
    
    // This is the action or function that will be called whenever the button is pressed
    func goToMyContactsViewController() {
        let contactsViewController = RetrieveContactsViewController()
            
        navigationController?.pushViewController(contactsViewController, animated: true)
        
    }
    
    func setupButtonPlacement() {
        
        // Add the button to this ViewController's view in the same way that it would be dragged on screen in the storyboard
        
        self.view.addSubview(button)
        
        
        // Configure the constraints (where it will be located, etc.)
        // UI elements have a few anchors such as:
        
        /*
        button.leftAnchor
        button.leadingAnchor
        button.topAnchor
        button.trailingAnchor
        button.rightAnchor
        button.bottomAnchor
        */
        
                                                                        // Activate the constraint
        button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
                                // Set the middle of this button to the
                                // middle of the entire view
        
        button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        button.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        button.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        setupButtonPlacement()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

