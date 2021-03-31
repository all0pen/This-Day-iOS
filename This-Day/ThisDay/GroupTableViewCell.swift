//
//  GroupTableViewCell.swift
//  ThisDay
//
//  Created by dm17 on 2019. 1. 15..
//  Copyright © 2019년 Digital Media. All rights reserved.
//

import UIKit

class GroupTableViewCell: UITableViewCell {

    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var groupNameLabel: UILabel!
    @IBOutlet var finalDateLabel: UILabel!
    
    
    // view Controller의 viewDidLoad와 같다고 생각
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
