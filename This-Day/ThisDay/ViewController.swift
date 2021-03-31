//
//  ViewController.swift
//  LoginFlow
//
//  Created by dm05 on 2018. 12. 27..
//  Copyright © 2018년 Digital. All rights reserved.
//

import UIKit
import Alamofire
// 로그인 창 (로그인, 회원가입)

class ViewController: UIViewController {
    
    
    @IBOutlet weak var idField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    var info: [LoginInfo] = []
        
    override func viewDidLoad() { // view controller가 생성될 때 실행되는 함수
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.idField.placeholder = "아이디를 입력해주세요"
        self.passwordField.isSecureTextEntry = true
        self.passwordField.keyboardType = UIKeyboardType.alphabet
        self.passwordField.text = "alphabet"
    }
    
    @IBAction func SignInButton(_ sender: UIButton) {
        
        if idField.text!.isEmpty || passwordField.text!.isEmpty
        {
            let alert = UIAlertController(
                title: "Login Error",
                message: "아이디 또는 비밀번호를 입력하지않았습니다.",
                preferredStyle: UIAlertController.Style.alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                // do something when user press OK button, like deleting text in both fields or do nothing
            }
            
            alert.addAction(OKAction)
            
            present(alert, animated: true, completion: nil)
            return
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        // 불러오는 시점!!!
        let standardUserDefaults: UserDefaults
        standardUserDefaults = UserDefaults.standard
        
        guard let userID: String = standardUserDefaults.string(forKey: "userID") else {
            return
        }
        guard let userPW: String = standardUserDefaults.string(forKey: "userPW") else {
            return
        }
        self.idField.text = userID
        self.passwordField.text = userPW
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { // 세그 시작하기 전 동작 지정
        
        LoginInfo.shared.userID = self.idField.text
        LoginInfo.shared.userPassword = self.passwordField.text

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
                    
                    let filter = self.info.filter { (user) -> Bool in
                        
                        let id = LoginInfo.shared.userID
                        
                        if user.userID == id {
                            LoginInfo.shared.id = user.id
                        }
                        return user.userID == id
                    }
           
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

