//
//  MatiereController.swift
//  Manehej
//
//  Created by pommestore on 09/07/2018.
//  Copyright © 2018 octadev. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MatiereController: UIViewController ,UITableViewDelegate ,UITableViewDataSource {
    
    public var matieres : [Matiere] = []
    public var matiere : Matiere? = nil
    public var error : Bool?
    var progressView : ProgressBar?
    let defaults = UserDefaults.standard
    var iduser : String?
    var id_mat : String?
    var context :UIViewController?
    let refreshControl = UIRefreshControl()
    var semester = ""
    @IBOutlet weak var tableview: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
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
        return (self.matieres.count)
    }
    
    
    
    @IBAction func Close(_ sender: Any) {
        // self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        matiere = matieres[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MatiereCell")as! MatiereCell
        cell.initialiser(matier: matiere!)
        cell.tag = indexPath.row
        let tap = UITapGestureRecognizer(target: self,action: #selector(DetailMat(tapGestureRecognizer:)))
        cell.isUserInteractionEnabled = true
        cell.addGestureRecognizer(tap)
        return cell
    }
    
    @objc func DetailMat(tapGestureRecognizer: UITapGestureRecognizer){
        let  mat = matieres[(tapGestureRecognizer.view?.tag)!]
        if #available(iOS 11.0, *) {
            let VC1 = self.storyboard?.instantiateViewController(withIdentifier: "DetailMatiereController")as! DetailMatiereController
            VC1.idmatiere = mat.id?.description as! String
            VC1.name = (mat.name)!
            VC1.semester = semester
            self.context!.present(VC1, animated: true, completion: nil)
            
        } else {
        }
    }
    
    
    func GetClass(){
        var parameters: Parameters = [
            "id_level": self.id_mat as! String,
        ]
        if(semester == "2"){
            parameters["semester"] = "2"
        }
        print(parameters)
        Alamofire.request(ListeMatiere, method: .post, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                self.progressView?.isHidden = true
                self.tableview.separatorStyle = UITableViewCellSeparatorStyle.singleLine
                if let results = response.result.value as? NSDictionary{
                    self.error = results["error"] as? Bool
                    if (self.error == true){
                        print("error")
                    }else{
                        if (results["matiere"] != nil) { self.matieres = Matiere.modelsFromDictionaryArray(array: results["matiere"] as! NSArray)
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
