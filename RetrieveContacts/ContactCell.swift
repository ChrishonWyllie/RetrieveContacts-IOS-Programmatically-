//
//  ContactCell.swift
//  RetrieveContacts
//
//  Created by Chrishon Wyllie on 1/18/17.
//  Copyright © 2017 Chrishon Wyllie. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {
    
    var contactNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(contactNameLabel)
        contactNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        contactNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        contactNameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
