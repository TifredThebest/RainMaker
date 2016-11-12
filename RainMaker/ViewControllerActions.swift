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


class ViewControllerActions: UIViewController ,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var deviceName: UILabel!
    
    @IBOutlet weak var statusTable: UITableView!
    
    @IBOutlet weak var actionsTable: UITableView!
    
    var actions = [String]()
    var variables = [String]()
    
    var deviceSelected = device.init(name: "error", connected: "error", lastIP: "error", ID: "error")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        deviceName.text = deviceSelected.name
        Alamofire.request("https://api.particle.io/v1/devices/\(deviceSelected.ID!)?access_token=\(accessToken)", method: .get).responseJSON { response in
            switch response.result {
                
            case .success(let value):
                let json = JSON(value)
                let funcArray = json["functions"].arrayValue
                let varArray = json["variables"].arrayValue
                
                for i in funcArray {
                    self.actions.append(i.stringValue)
                    self.actionsTable.reloadData()
                }
                
                for j in varArray {
                    self.variables.append(j.stringValue)
                    self.statusTable.reloadData()
                }
                
                
            case .failure(let error):
                print(error)
            }
            
            
        }}
    
    
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
        
    }

 
    

    

}
