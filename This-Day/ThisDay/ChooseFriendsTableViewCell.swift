//
//  ChooseFriendsTableViewCell.swift
//  
//
//  Created by dm05 on 2019. 1. 14..
//

import UIKit

class ChooseFriendsTableViewCell: UITableViewCell {
    
    @IBOutlet var friendsName: UILabel!
    @IBOutlet var id: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
