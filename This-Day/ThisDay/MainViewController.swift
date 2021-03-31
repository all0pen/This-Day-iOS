//
//  MainViewController.swift
//  ThisDay
//
//  Created by dm05 on 2019. 1. 9..
//  Copyright © 2019년 Digital Media. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var idLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    var info: LoginInfo? = LoginInfo.shared
    var memo = ["iOS 공부하기", "책 읽기", "밥 먹기"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ToDoTableViewCell = tableView.dequeueReusableCell(withIdentifier: "toDoCell", for: indexPath) as! ToDoTableViewCell
        
        cell.memoLabel?.text = memo[indexPath.row]
        
        return cell
    }
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let id = self.info?.userID else {
            print("전달받은 id 없음")
            return
        }

        self.idLabel.text = id
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { // 세그 시작하기 전 동작 지정
        
        // segue의 목적지가 스케줄 매칭일 경우
        guard let group: GroupViewController = segue.destination as? GroupViewController
            else {
                print("목적지가 group view가 아님")
                return
        }
        
        // segue의 목적지가 내 캘린더일 경우
        guard let cal: CalendarViewController = segue.destination as? CalendarViewController else {
            print("목적지가 calendar view가 아님")
            return
        }
        
        group.info = info
        cal.info = info
    }
}
