//
//  NotificationController.swift
//  Manehej
//
//  Created by pommestore on 24/07/2018.
//  Copyright © 2018 octadev. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class NotificationController: UIViewController , UITableViewDataSource , UITableViewDelegate {
    public var notifications : [Notification] = []
    public var notif : Notification? = nil
    public var error : Bool?
    var progressView : ProgressBar?
    let defaults = UserDefaults.standard
    var iduser : String?
    
    let refreshControl = UIRefreshControl()
    @IBOutlet weak var tableview: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        iduser = defaults.string(forKey: "user_uid")
        self.tableview.delegate = self
        self.tableview.dataSource = self
        
        // Do any additional setup after loading the view.
        
        
        progressView = ProgressBar(frame: CGRect(origin:
            CGPoint.zero, size: CGSize(width:50, height:50)))
        progressView?.center = self.view.center
        self.view.addSubview(progressView!)
        
        if #available(iOS 10.0, *) {
            tableview.refreshControl = refreshControl
        } else {
            tableview.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        GetClass()
        
    }
    @objc private func refreshWeatherData(_ sender: Any) {
        GetClass()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.notifications.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        notif = notifications[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell")as! NotificationCell
        cell.initialiser(notification: notif!)
        
        cell.desc.tag = indexPath.row
        let tap = UITapGestureRecognizer(target: self,action: #selector(showDelete(tapGestureRecognizer:)))
        cell.desc.isUserInteractionEnabled = true
        cell.desc.addGestureRecognizer(tap)
        return cell
        
    }
    @objc func showDelete(tapGestureRecognizer: UITapGestureRecognizer){
        
        let pos = tapGestureRecognizer.view?.tag
        let indexPath = IndexPath(row: pos!, section: 0)
        let cell = self.tableview.cellForRow(at: indexPath)as! NotificationCell
        
        if notifications[pos!].show == false {
            notifications[pos!].show = true
            cell.width_.constant = 23
        }else{
            notifications[pos!].show = false
            cell.width_.constant = 0
            
        }
    }
    
    
    func GetClass(){
        let parameters: Parameters = [
            "id_user": iduser?.description
        ]
        Alamofire.request(NotificationUser , method: .post, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                self.progressView?.isHidden = true
                self.tableview.separatorStyle = UITableViewCellSeparatorStyle.singleLine
                if let results = response.result.value as? NSDictionary{
                    self.error = results["error"] as? Bool
                    if (self.error == true){
                        print("error")
                    }else{
                        if (results["Notification"] != nil) { self.notifications = Notification.modelsFromDictionaryArray(array: results["Notification"] as! NSArray)
                                self.tableview.reloadData()
                                self.refreshControl.endRefreshing()
                        }
                    }
                }
            }
            else
                if response.result.isFailure {
                    print ("chiheb")
            }
        }
        
    }
    
}
