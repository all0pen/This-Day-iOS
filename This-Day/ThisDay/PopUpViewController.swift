//
//  PopUpViewController.swift
//  ThisDay
//
//  Created by dm05 on 2019. 1. 15..
//  Copyright © 2019년 Digital Media. All rights reserved.
//

import UIKit
import CVCalendar

class PopUpViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var selectedDayLabel: UILabel!
    var selectedDate: CVDate!
    var calendarInfo: [CalendarInfo] = []
    
    var info: LoginInfo? = LoginInfo.shared
    var dateString: String?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return calendarInfo.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: CalendarToDoTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CalendarToDoCell", for: indexPath) as! CalendarToDoTableViewCell
        
        let info: CalendarInfo = self.calendarInfo[indexPath.row]
        cell.titleLabel.text = info.title
        
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        
        guard let date: CVDate = self.selectedDate else {
            print("날짜 전달 안됨")
            return
        }
        
        print("\(date.year) \(date.month) \(date.day)")
        
        self.selectedDayLabel.text = "\(date.year)년 \(date.month)월 \(date.day)일"
        
        dateString = "\(date.year) \(date.month) \(date.day)"
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navi = segue.destination as? UINavigationController else {
            print("목적지가 내비가 아님")
            return
        }

        guard let destination: AddToDoViewController = navi.viewControllers.first as? AddToDoViewController else {
            print("목적지가 할 일 추가가 아님")
            return
        }
        destination.delegate = self
        destination.selectedDate = self.selectedDate
        destination.userID = self.info?.id
        
    }
    
    // 이 창의 modal view 아래로 내리기
    @IBAction func touchUpDismissButton(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
}
