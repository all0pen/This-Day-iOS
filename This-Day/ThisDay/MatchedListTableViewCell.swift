//
//  MatchedListTableViewCell.swift
//  ThisDay
//
//  Created by dm05 on 2019. 1. 10..
//  Copyright © 2019년 Digital Media. All rights reserved.
//

import UIKit

class MatchedListTableViewCell: UITableViewCell {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var schedule: UILabel!
    @IBOutlet var dayLabel: UILabel! // dayLabel에 모임의 기간 넣어야 한다.
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
