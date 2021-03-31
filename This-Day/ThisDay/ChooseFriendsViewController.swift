//
//  ChooseFriendsViewController.swift
//  
//
//  Created by dm05 on 2019. 1. 14..
//

import UIKit
import Alamofire

class ChooseFriendsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var friends: [FriendsList] = []
    var info: LoginInfo? = LoginInfo.shared
    var fullInfo: [LoginInfo] = []
    var selected: [Int] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell: ChooseFriendsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "friendList", for: indexPath) as! ChooseFriendsTableViewCell
        
        let friend: FriendsList = self.friends[indexPath.row]
        
        Alamofire.request("http://ldy.codegrapher.io/account/list/").responseJSON { (response2) in
            
            switch response2.result {
            case .success(let value):
                print("finish")
                
                if let error: Error = response2.error {
                    print("네트워크 요청 오류발생")
                    print(error.localizedDescription)
                    return
                }
                
                guard var data: Data = response2.data else {
                    print("data 없음")
                    return
                }
                
                let jsonString = String(data: data, encoding: .utf8)
                print(jsonString)
                
                let decoder: JSONDecoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                do {
                    self.fullInfo = try
                        decoder.decode([LoginInfo].self, from: data)
                    
                    let filter = self.fullInfo.filter { (name) -> Bool in
                        
                        if name.id == friend.user2 {
                            cell.friendsName.text = name.userID
                        }
                        return name.id == friend.user2
                    }
                    
                } catch {
                    print("JSON 디코드 오류 발생")
                    print(error.localizedDescription)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        
        // cell이 선택되면 선택된친구목록에 추가하기
        if (cell.accessoryType == UITableViewCell.AccessoryType.checkmark){
            cell.accessoryType = UITableViewCell.AccessoryType.none;
        } else {
            cell.accessoryType = UITableViewCell.AccessoryType.checkmark;
            
        }
    }    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            friends.remove(at: indexPath.row)
            
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        Alamofire.request("http://ldy.codegrapher.io/friend/list/").responseJSON { (response) in
            
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
                    
                    self.friends = try
                        decoder.decode([FriendsList].self, from: data)
                    
                    let filter = self.friends.filter { (friend) -> Bool in
                        
                        return friend.user1 == LoginInfo.shared.id
                    }
                    
                    self.friends = filter
                    self.tableView.reloadData()
                    
                } catch {
                    print("JSON 디코드 오류 발생")
                    print(error.localizedDescription)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        tableView.allowsMultipleSelection = true

    }
    
    @IBAction func touchUpNextButton (_ sender: UIBarButtonItem) {
        
        guard let selectedIndexs: [IndexPath] = self.tableView.indexPathsForSelectedRows, selectedIndexs.count > 0 else {
            print("선택된 친구 없음")
            return
        }
        
        for index in selectedIndexs {
            self.selected.append(self.friends[index.row].user2)
            
        }
        print(self.selected)
        
        self.performSegue(withIdentifier: "showMatching", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let destination: CreateGroupViewController = segue.destination as? CreateGroupViewController else {
            return
        }
        
        destination.memberList = self.selected
        
    }

}
