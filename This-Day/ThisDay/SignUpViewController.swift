//
//  SignUpViewController.swift
//  ThisDay
//
//  Created by dm05 on 2019. 1. 14..
//  Copyright © 2019년 Digital Media. All rights reserved.
//

import UIKit
import Alamofire

class SignUpViewController: UIViewController {
    
    @IBOutlet var idField: UITextField!
    @IBOutlet var passwordField: UITextField!

    @IBAction func touchUpSignUpButton(_sender: UIButton) {
        
        guard let id: String = self.idField.text else {
            print("id 입력 안함")
            return
        }
        
        guard let password: String = self.passwordField.text else {
            print("password 입력 안함")
            return
        }
        
        var info: LoginInfo = LoginInfo()
        info.userID = id
        info.userPassword = password

        let encoder: JSONEncoder = JSONEncoder()
        
        guard let jsonData: Data = try? encoder.encode(info) else {
            print("json data 변환 실패")
            return
        }
        
        guard var request: URLRequest = try? URLRequest(url: "http://ldy.codegrapher.io/account/list/", method: HTTPMethod.post) else {
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
                    let user: LoginInfo = try decoder.decode(LoginInfo.self, from: response.data!)
                    LoginInfo.shared.id = user.id
                    LoginInfo.shared.userPassword = user.userPassword
                    LoginInfo.shared.userID = user.userID
                    
                    let userDefaults: UserDefaults = .standard
                    
                    userDefaults.set(user.userID, forKey: "userID")
                    userDefaults.set(user.userPassword, forKey: "userPW")
                    userDefaults.synchronize()
                    
                    
                } catch {
                    print("회원가입 정보 디코드 오류 " + error.localizedDescription)
                }
                
                
                // 회원가입 완료되면 modal 창 내리기
                self.presentingViewController?.dismiss(animated: true, completion: nil)
                
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
