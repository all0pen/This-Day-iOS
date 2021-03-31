//
//  ViewController.swift
//  ContactFromWeb
//
//  Created by dm15 on 2019. 1. 4..
//  Copyright © 2019년 Digital Media. All rights reserved.
//

import UIKit
import Alamofire

class GroupViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    var groups: [GroupInfo] = []
    var dates = [Int]()
    var groupName: String?
    var finalDate: String?
    var info: LoginInfo? = LoginInfo.shared
    
    @IBOutlet var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: GroupTableViewCell = tableView.dequeueReusableCell(withIdentifier: "groupListCell", for: indexPath) as! GroupTableViewCell
        
        let group: GroupInfo = self.groups[indexPath.row]
        cell.groupNameLabel?.text = group.groupName
        cell.finalDateLabel?.text = group.finalDate
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            groups.remove(at: indexPath.row)
            
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { // 세그 시작하기 전 동작 지정
        
        guard let cell: GroupTableViewCell = sender as? GroupTableViewCell else {
            return
        }
        
        guard let index: IndexPath = self.tableView.indexPath(for: cell) else {
            return
        }
        
        let row: Int = index.row
        
        let group: GroupInfo = self.groups[row]
        
        guard let destination: VoteViewController = segue.destination as? VoteViewController // segue의 목적지를 지정
            else {
                return
        }
        
        destination.info = group
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Alamofire.request("http://ldy.codegrapher.io/this/group/list/").responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                print("finish")
                
                if let error: Error = response.error {
                    print("네트워크 요청 오류발생")
                    print(error.localizedDescription)
                    return
                }
                
                guard var data: Data = response.data else {
                    print("data 없음")
                    return
                }
                
                let jsonString = String(data: data, encoding: .utf8)
                print(jsonString)
                
                let decoder: JSONDecoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                do {
                    self.groups = try
                        decoder.decode([GroupInfo].self, from: data)
                    
                    self.tableView.reloadData()
                    
                } catch {
                    print("JSON 디코드 오류 발생")
                    print(error.localizedDescription)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
}

