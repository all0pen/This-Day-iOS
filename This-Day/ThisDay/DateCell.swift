//
//  CreateGroupTableViewCell.swift
//  ThisDay
//
//  Created by dm17 on 2019. 1. 15..
//  Copyright © 2019년 Digital Media. All rights reserved.
//

import UIKit

protocol DateCellDelegate {
    func dateCellDidDateChanged(_ sender: DateCell, dateString: String)
}

class DateCell: UITableViewCell {

    var delegate: DateCellDelegate?
    @IBOutlet var inputDateField: UITextField!
    
    override func awakeFromNib() {
        let datePicker = UIDatePicker()
        
        datePicker.datePickerMode = .dateAndTime
        
        datePicker.addTarget(self, action: #selector(DateCell.dateChanged(sender:)), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(DateCell.viewTapped(gestureRecognizer:)))
        
        self.addGestureRecognizer(tapGesture)
        
        inputDateField.inputView = datePicker
        
        // Do any additional setup after loading the view.
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        self.endEditing(true)
    }
    
    @objc func dateChanged(sender: UIDatePicker){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD'T'HH:mm:ss'Z"
        
        self.delegate?.dateCellDidDateChanged(self, dateString: dateFormatter.string(from: sender.date))
        
        inputDateField.text = dateFormatter.string(from: sender.date)
    }
    
    
}
