//
//  HomeController.swift
//  Manehej
//
//  Created by pommestore on 08/07/2018.
//  Copyright © 2018 octadev. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class HomeController: UIViewController , UITableViewDataSource , UITableViewDelegate {
    public var schoollevels : [Schoollevels] = []
    public var sch : Schoollevels? = nil
    public var error : Bool?
    var progressView : ProgressBar?
    let defaults = UserDefaults.standard
    var iduser : String?
    
    let refreshControl = UIRefreshControl()
    @IBOutlet weak var tableview: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.delegate = self
        self.tableview.dataSource = self
        iduser = defaults.string(forKey: "user_uid")
        
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
        return (self.schoollevels.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        sch = schoollevels[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell")as! HomeCell
        cell.initialiser(school: sch!)
        if indexPath.row > 0 {
            let sch1 = schoollevels[indexPath.row - 1]
            if sch1.level?.name != sch?.level?.name{
                cell.h_lev.constant = 45
            }else{
                cell.h_lev.constant = 0
            }
        }
        let tap = UITapGestureRecognizer(target: self,action: #selector(NextPage(tapGestureRecognizer:)))
        cell.level_action.isUserInteractionEnabled = true
        cell.level_action.addGestureRecognizer(tap)
        return cell
        
    }
    
    @objc func  NextPage(tapGestureRecognizer: UITapGestureRecognizer){
        let VC1 = self.storyboard?.instantiateViewController(withIdentifier: "MatierePager")as! MatierePager
        VC1.id_mat = (tapGestureRecognizer.view?.tag.description)!
        self.navigationController?.show(VC1, sender: self)
    }
    
    func GetClass(){
        let parameters: Parameters = [
            "id_user": iduser
        ]
        Alamofire.request(ListeClass, method: .post, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                self.progressView?.isHidden = true
                self.tableview.separatorStyle = UITableViewCellSeparatorStyle.singleLine
                if let results = response.result.value as? NSDictionary{
                    self.error = results["error"] as? Bool
                    if (self.error == true){
                        print("error")
                    }else{
                        if (results["schoollevels"] != nil) { self.schoollevels = Schoollevels.modelsFromDictionaryArray(array: results["schoollevels"] as! NSArray)
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
extension UIView {
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
}
