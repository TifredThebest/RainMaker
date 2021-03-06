//
//  ViewControllerActions.swift
//  RainMaker
//
//  Created by Jean Piard on 11/11/16.
//  Copyright © 2016 Jean Piard. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toast_Swift

var locationinString : String!
var deviceID : String!


 
class ViewControllerActions: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    
    var activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView()

    @IBAction func goToMap(_ sender: Any) {
        
            performSegue(withIdentifier: "toMaps", sender: nil)
   
    }
    @IBOutlet weak var deviceName: UILabel!
    
    @IBOutlet weak var statusTable: UITableView!
    
    @IBOutlet weak var actionsTable: UITableView!
    
    var deviceSelected = device.init(name: "error", connected: "error", lastIP: "error", ID: "error")
    var actions = [String]()
    var variables = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statusTable.delegate = self
        statusTable.dataSource = self
        
        actionsTable.delegate = self
        actionsTable.dataSource = self

        deviceName.text = deviceSelected.name
        deviceID = deviceSelected.ID
        let parameters: Parameters = [
            
            "devId":deviceSelected.ID!,
            "access_token":accessToken,]
        
        
        Alamofire.request("http://ec2-54-84-46-40.compute-1.amazonaws.com:9000/attributes", method: .post,parameters: parameters).responseJSON { response in
            switch response.result {
                
            case .success(let value):
                
                let json = JSON(value)
                
                let funcArray = json["data"]["functions"].arrayValue
                let varArray = json["data"]["variables"]
                
                for i in funcArray {
                    self.actions.append(i.stringValue)
                    self.actionsTable.reloadData()
                }
                
                for (myKey,_) in varArray {
                    self.variables.append(myKey)
                    self.statusTable.reloadData()
                }
                
                
                
                
            case .failure(let error):
                print(error)
            }
            
            
        }
    
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        
       
        
        let parameter: Parameters = [
            "devId":deviceSelected.ID!,
            "access_token":accessToken,
            "variableName":"coords",]
        
        let url = "http://ec2-54-84-46-40.compute-1.amazonaws.com:9000/value"
        
        Alamofire.request(url, method: .post,parameters: parameter).responseJSON { response in
            switch response.result {
                
            case .success(let value):
                let json = JSON(value)
                let varVal = json["variableValue"]["body"]["result"].stringValue
                if(!varVal.isEmpty){
                   
                    locationinString = varVal
                      
                }
                
                
                
                
            case .failure(let error):
                print(error)
            }
            
            
        }
        
        activityIndicator.stopAnimating()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == statusTable{
         return variables.count
            
        }
        else if tableView == actionsTable{
        return actions.count
            
        
        }
        
        return Int()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if(tableView == actionsTable ){
            
        let cell = UITableViewCell()
       cell.textLabel?.text = actions[indexPath.row]
            
        return cell }
            
        else if tableView == statusTable{
            
            let cell = UITableViewCell()
        cell.textLabel?.text = variables[indexPath.row]
            
        return cell
        }
        
    
        return UITableViewCell()
        
        
        
    }




    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        
        if(tableView == actionsTable){
            
            let url = "https://api.particle.io/v1/devices/\(deviceSelected.ID!)/\(tableView.cellForRow(at: indexPath)!.textLabel!.text!)?arg=rando&access_token=\(accessToken)"
            

            Alamofire.request(url, method: .post).responseJSON { response in
                switch response.result {
                    
                case .success(let value):
                    let json = JSON(value)
                    print(json)
             
                    
                    
                case .failure(let error):
                    print(error)
                }
                
                
            }
        }
        else{
            let parameter: Parameters = [
                
                "devId":deviceSelected.ID!,
                "access_token":accessToken,
                "variableName":tableView.cellForRow(at: indexPath)!.textLabel!.text!,]
            
            let url = "http://ec2-54-84-46-40.compute-1.amazonaws.com:9000/value"
        
            Alamofire.request(url, method: .post,parameters: parameter).responseJSON { response in
                switch response.result {
                    
                case .success(let value):
                    let json = JSON(value)
                    let varVal = json["variableValue"]["body"]["result"].stringValue
                    if(!varVal.isEmpty){
                        self.view.makeToast(varVal, duration: 3.0, position: .bottom)
                     print(varVal)
                    }
                    
                   
                
                   
                case .failure(let error):
                    print(error)
                }
                
                
            }}
        
    }

    
  

    

    

}
