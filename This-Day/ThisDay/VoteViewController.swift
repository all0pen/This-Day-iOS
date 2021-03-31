//
//  ViewController.swift
//  ContactFromWeb
//
//  Created by dm15 on 2019. 1. 4..
//  Copyright © 2019년 Digital Media. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

struct DateInfo: Codable {
    var date: Date
}

class VoteViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
 
    // cell의 특정 group info.
    var info: GroupInfo?
    var dateList: [Int] = []
    var voteFinal: String!
    
    @IBOutlet var groupNameLabel: UILabel!
    @IBOutlet var finalDateLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        var cell:VoteTableViewCell!
        switch row {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: "voteCell", for: indexPath) as! VoteTableViewCell
            cell.dateLabel.text = self.info?.vote1
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: "voteCell", for: indexPath) as! VoteTableViewCell
            cell.dateLabel.text = self.info?.vote2
        case 2:
            cell = tableView.dequeueReusableCell(withIdentifier: "voteCell", for: indexPath) as! VoteTableViewCell
            cell.dateLabel.text = self.info?.vote3
        case 3:
            cell = tableView.dequeueReusableCell(withIdentifier: "voteCell", for: indexPath) as! VoteTableViewCell
            cell.dateLabel.text = self.info?.vote4
        case 4:
            cell = tableView.dequeueReusableCell(withIdentifier: "voteCell", for: indexPath) as! VoteTableViewCell
            cell.dateLabel.text = self.info?.vote5
        default:
            cell.dateLabel.text = self.info?.vote1
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        
        if (cell.accessoryType == UITableViewCell.AccessoryType.checkmark){
            cell.accessoryType = UITableViewCell.AccessoryType.none;
        } else {
            cell.accessoryType = UITableViewCell.AccessoryType.checkmark;
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    
        self.tableView.allowsMultipleSelection = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.groupNameLabel.text = info?.groupName
        self.finalDateLabel.text = info?.finalDate
    }
    
    @IBAction func touchUpOKButton(_sender: UIButton) {
        
        let encoder: JSONEncoder = JSONEncoder()
        
        guard let jsonData: Data = try? encoder.encode(info) else {
            print("json data 변환 실패")
            return
        }
        
        guard var request: URLRequest = try? URLRequest(url: "http://ldy.codegrapher.io/this/group/list/vote", method: HTTPMethod.post) else {
            return
        }
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = jsonData
        
        Alamofire.request(request).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print("finish")

                
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    
    }
    
    @IBAction func touchUpOkButton (_ sender: UIBarButtonItem) {
        
        guard let selectedIndexs: [IndexPath] = self.tableView.indexPathsForSelectedRows, selectedIndexs.count > 0 else {
            print("선택된 친구 없음")
            return
        }
        
        for index in selectedIndexs {
            self.voteFinal = self.info!.vote4
            
        }
        
        self.performSegue(withIdentifier: "showResult", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let finalResult: FinalVoteViewController = segue.destination as? FinalVoteViewController else {
            print("최종 투표 결과 뷰가 아님")
            return
        }
        
        finalResult.groupN = self.groupNameLabel.text
        finalResult.finalD = self.voteFinal
        
    }
}
