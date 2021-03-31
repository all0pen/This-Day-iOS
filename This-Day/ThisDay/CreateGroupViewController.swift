//
//  CreateGroupViewController.swift
//  ThisDay
//
//  Created by dm17 on 2019. 1. 15..
//  Copyright © 2019년 Digital Media. All rights reserved.
//

import UIKit
import Alamofire

class CreateGroupViewController: UIViewController {
    
//    @IBOutlet var tableView: UITableView!
    @IBOutlet var groupNameField: UITextField!
    @IBOutlet var finalDateField: UITextField!
    @IBOutlet var memberLabel1: UILabel!
    @IBOutlet var memberLabel2: UILabel!
    @IBOutlet var memberLabel3: UILabel!
    @IBOutlet var memberLabel4: UILabel!
    @IBOutlet var memberLabel5: UILabel!
    @IBOutlet var inputDateField1: UITextField!
    @IBOutlet var inputDateField2: UITextField!
    @IBOutlet var inputDateField3: UITextField!
    @IBOutlet var inputDateField4: UITextField!
    @IBOutlet var inputDateField5: UITextField!
    
    var dates = [String]()
    var memberList: [Int] = []
    var loginInfo: LoginInfo? = LoginInfo.shared
    
    var info: GroupInfo?
    
    private var datePicker: UIDatePicker?
    
    @IBAction func touchUpCreateGroupButton(_sender: UIBarButtonItem) {
        
        guard let name: String = self.groupNameField.text else {
            print("그룹명 입력 안함")
            return
        }
        
        guard let dateF: String = self.finalDateField.text else {
            print("마감날짜 입력 안함")
            return
        }
        
        guard let dateLists: [String] = self.dates else {
            print("날짜들 선택 입력 안함")
            return
        }
        
        var info: GroupInfo = GroupInfo()
        
        // **************** 여기 고치기 ****************
//        info.voteList = dateLists
        info.vote1 = self.inputDateField1.text
        info.vote2 = self.inputDateField2.text
        info.vote3 = self.inputDateField3.text
        info.vote4 = self.inputDateField4.text
        info.vote5 = self.inputDateField5.text
        info.groupName = name
        info.finalDate = dateF
//        info.memberList
        info.member1 = self.memberList[0]
        info.member2 = self.memberList[1]
        info.member3 = self.memberList[2]
        info.member4 = self.memberList[3]
        info.member5 = self.memberList[4]
        info.fixedSchedule = "2019-01-24"
        
        let encoder: JSONEncoder = JSONEncoder()
        
        guard let jsonData: Data = try? encoder.encode(info) else {
            print("json data 변환 실패")
            return
        }
        
        guard var request: URLRequest = try? URLRequest(url: "http://ldy.codegrapher.io/this/group/list/", method: HTTPMethod.post) else {
            return
        }
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = jsonData
        let utf8Text = String(data: jsonData, encoding: .utf8)
        print("Data: \(utf8Text)")
        
        Alamofire.request(request).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print("finish")
                
                if let data = response.data {
                    let string = String(data: data, encoding: String.Encoding.utf8)
                    print(string)
                }
                
                
                guard let group = self.presentingViewController?.presentingViewController as? GroupViewController else {
                    print("group 아님")
                    return
                }
                self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func dismissModal() {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dates = []
        
        let datePicker = UIDatePicker()
        let datePicker1 = UIDatePicker()
        let datePicker2 = UIDatePicker()
        let datePicker3 = UIDatePicker()
        let datePicker4 = UIDatePicker()
        let datePicker5 = UIDatePicker()
        
        datePicker.datePickerMode = .date
        datePicker1.datePickerMode = .date
        datePicker2.datePickerMode = .date
        datePicker3.datePickerMode = .date
        datePicker4.datePickerMode = .date
        datePicker5.datePickerMode = .date
        
        datePicker.addTarget(self, action: #selector(self.dateChanged(sender:)), for: .valueChanged)
        datePicker1.addTarget(self, action: #selector(self.datePicked1(_:)), for: .valueChanged)
        datePicker2.addTarget(self, action: #selector(self.datePicked2(_:)), for: .valueChanged)
        datePicker3.addTarget(self, action: #selector(self.datePicked3(_:)), for: .valueChanged)
        datePicker4.addTarget(self, action: #selector(self.datePicked4(_:)), for: .valueChanged)
        datePicker5.addTarget(self, action: #selector(self.datePicked5(_:)), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(DateCell.viewTapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tapGesture)
        
        finalDateField.inputView = datePicker
        inputDateField1.inputView = datePicker1
        inputDateField2.inputView = datePicker2
        inputDateField3.inputView = datePicker3
        inputDateField4.inputView = datePicker4
        inputDateField5.inputView = datePicker5
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let destination: GroupViewController = segue.destination as? GroupViewController
            else {
                return
        }
    }
    
    @objc func datePicked1(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        inputDateField1.text = dateFormatter.string(from: sender.date)
    }
    @objc func datePicked2(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        inputDateField2.text = dateFormatter.string(from: sender.date)
    }
    @objc func datePicked3(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        inputDateField3.text = dateFormatter.string(from: sender.date)
    }
    @objc func datePicked4(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        inputDateField4.text = dateFormatter.string(from: sender.date)
    }
    @objc func datePicked5(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        inputDateField5.text = dateFormatter.string(from: sender.date)
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func dateChanged(sender: UIDatePicker){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        finalDateField.text = dateFormatter.string(from: sender.date)
    }
    
}
