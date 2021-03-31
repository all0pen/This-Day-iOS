//
//  FinalVoteViewController.swift
//  ThisDay
//
//  Created by swuad_33 on 2019. 1. 18..
//  Copyright © 2019년 Digital Media. All rights reserved.
//

import UIKit

class FinalVoteViewController: UIViewController {

    @IBOutlet var finalDate: UILabel!
    @IBOutlet var groupName: UILabel!
    var finalD: String?
    var groupN: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.finalDate.text = self.finalD
        self.groupName.text = self.groupN
    }

    
}
