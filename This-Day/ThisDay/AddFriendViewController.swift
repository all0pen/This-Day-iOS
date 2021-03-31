//
//  AddFriendViewController.swift
//  ThisDay
//
//  Created by swuad_33 on 2019. 1. 17..
//  Copyright © 2019년 Digital Media. All rights reserved.
//

import UIKit
import Alamofire


class AddFriendViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    var info: [LoginInfo] = []
    var loginInfo: LoginInfo = LoginInfo.shared
    var checkedFriend: String?
    var checkedFK: Int!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return info.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: AddFriendTableViewCell = tableView.dequeueReusableCell(withIdentifier: "addFriend", for: indexPath) as! AddFriendTableViewCell
        
        let friendInfo: LoginInfo = self.info[indexPath.row]
        cell.nameLabel.text = friendInfo.userID
        self.checkedFK = friendInfo.id
        
        self.checkedFriend = cell.nameLabel.text
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        Alamofire.request("http://ldy.codegrapher.io/account/list/").responseJSON { (response) in
            
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
                    self.info = try
                        decoder.decode([LoginInfo].self, from: data)
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
    
    @IBAction func touchUpAddButton (_sender: UIButton) {
        
        guard let selectedIndexs: [IndexPath] = self.tableView.indexPathsForSelectedRows, selectedIndexs.count > 0 else {
            print("선택된 친구 없음")
            return
        }
        
        var selectedFriends: [LoginInfo] = []
        
        for index in selectedIndexs {
            selectedFriends.append(self.info[index.row])
        }
        
        var friendship: FriendsList = FriendsList(user1: self.loginInfo.id!, user2: selectedFriends[0].id!)
        
        let encoder: JSONEncoder = JSONEncoder()
        
        guard let jsonData: Data = try? encoder.encode(friendship) else {
            print("json data 변환 실패")
            return
        }
        
        guard var request: URLRequest = try? URLRequest(url: "http://ldy.codegrapher.io/friend/list/", method: HTTPMethod.post) else {
            return
        }
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = jsonData
        
        Alamofire.request(request).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print("finish")
                
                do {
                    let decoder: JSONDecoder = JSONDecoder()
                    let friend: FriendsList = try decoder.decode(FriendsList.self, from: response.data!)
                    print(friend.user1, friend.user2)
                    
                    
                } catch {
                    print("친구 추가 디코드 오류 " + error.localizedDescription)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}
