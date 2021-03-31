//
//  AddToDoViewController.swift
//  ThisDay
//
//  Created by dm05 on 2019. 1. 9..
//  Copyright © 2019년 Digital Media. All rights reserved.
//

import UIKit
import CVCalendar
import Alamofire

// 할 일 추가하는 view controller

class AddToDoViewController: UIViewController {

    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var memoField: UITextField!
    var selectedDate: CVDate!
    var userID: Int?
//    var dateString: String?
    var delegate:PopUpViewController!
    
    @IBAction func touchUpAddButton(_sender: UIBarButtonItem) {
        
        guard let title: String = self.titleField.text,
        title.isEmpty == false else {
            print("title 입력 안함")
            return
        }
        
        guard let memo: String = self.memoField.text,
        memo.isEmpty == false else {
            print("memo 입력 안함")
            return
        }
        
       let dateString = "\(self.selectedDate.year)-\(self.selectedDate.month)-\(self.selectedDate.day)"
        
        var info: CalendarInfo = CalendarInfo(title: title, memo: memo, date: dateString ,userID: 1)
        let encoder: JSONEncoder = JSONEncoder()
        
        guard let jsonData: Data = try? encoder.encode(info) else {
            print("json data 변환 실패")
            return
        }
        
        guard var request: URLRequest = try? URLRequest(url: "http://ldy.codegrapher.io/cal/calendar/list/", method: HTTPMethod.post) else {
            return
        }
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = jsonData
        
        Alamofire.request(request).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print("finish")
                print(String(data: jsonData, encoding: .utf8))
                print("view name",String(describing: self.presentedViewController))
                
                self.delegate.calendarInfo.append(info)
                self.dismiss(animated: true, completion: nil)
                guard let navi = self.navigationController?.presentingViewController as? UINavigationController else {
                    print("이전 화면의 내비 없음")
                    return
                }
                guard let destination = navi.viewControllers.last as? PopUpViewController else {
                    print("이전 화면이 pop up view controller 아님")
                    return
                }
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-\(0)M-dd"
                
                // 정보 pop up view controller로 보내기
                var newInfo: CalendarInfo = CalendarInfo()
                newInfo.userID = self.userID
                newInfo.title = title
                    // self.titleField.text
                newInfo.memo = memo
                    // self.memoField.text
                newInfo.date = dateFormatter.string(from: Date())
                
                destination.calendarInfo.append(newInfo)
                
                self.navigationController?.presentingViewController?.dismiss(animated: true, completion: nil)
                
                destination.tableView.reloadData()
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    @IBAction func touchUpCancelButton(_ sender: UIBarButtonItem) {
        
        self.navigationController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.titleField.placeholder = "할 일 제목을 입력"
        
        // 불러오는 시점!!!
        let standardUserDefaults: UserDefaults
        standardUserDefaults = UserDefaults.standard
        
        guard let title: String = standardUserDefaults.string(forKey: "title") else {
            return
        }
        
        guard let memo: String = standardUserDefaults.string(forKey: "memo") else {
            return
        }
        
        self.titleField.text = title
        self.memoField.text = memo
        
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let destination: PopUpViewController = segue.destination as? PopUpViewController
            else {
                return
        }
        
        
        
    }
    
}
