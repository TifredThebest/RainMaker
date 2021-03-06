//
//  ViewController.swift
//  RainMaker
//
//  Created by Jean Piard on 11/4/16.
//  Copyright © 2016 Jean Piard. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

var accessToken = ""
var devices = [device]()
var userNameInfo = ""
var passwordInfo = ""

class ViewController: UIViewController {

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    
   
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func SignIn(_ sender: Any) {
         userNameInfo = userName.text!
         passwordInfo = password.text!
        
      
        
                let parameters: Parameters = [

                    "login":userNameInfo,
                    "password":passwordInfo,]
        
        Alamofire.request("http://ec2-54-84-46-40.compute-1.amazonaws.com:9000/login", method: .post,parameters :parameters).responseJSON { response in
                    switch response.result {
        
                    case .success(let value):
                        let json = JSON(value)
                        accessToken = json["accessToken"].stringValue
                        print(json);
                        
                        for i in 0...(json["devices"].array?.count)!-1 {

                                                let name: String = json["devices"][i]["name"].stringValue
                                                let connected : String = json["devices"][i]["connected"].stringValue
                                                let lastIp : String = json["devices"][i]["last_ip_address"].stringValue
                                                let id : String = json["devices"][i]["id"].stringValue
                            
                                                devices.append(device.init(name: name, connected: connected, lastIP: lastIp, ID: id))

                                            }
                        
        
                        self.performSegue(withIdentifier: "SignInComplete", sender: self)
        
                    case .failure(let error):
                        print(error)
                    }
                    
                   
        }
        
    }
}
