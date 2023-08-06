//
//  ResponseController.swift
//  Manehej
//
//  Created by pommestore on 21/07/2018.
//  Copyright © 2018 octadev. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class ResponseController: UIViewController ,UITableViewDataSource , UITableViewDelegate{
    @IBOutlet weak var clas: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var photo: CircleImage!
    @IBOutlet weak var user_name: UILabel!
    @IBOutlet weak var card: UIView!
    @IBOutlet weak var desc: UILabel!
    
    @IBOutlet weak var res_text: UITextField!
    @IBOutlet weak var tableview: UITableView!
    let refreshControl = UIRefreshControl()
    var responses : [Response] = []
    var response : Response?
    var question : Questions?
    
    var id_question = ""
    public var error : Bool?
    var progressView : ProgressBar?
    let defaults = UserDefaults.standard
    var iduser : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        iduser = defaults.string(forKey: "user_uid")
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        print("error ResponseController")

        desc.lineBreakMode = .byWordWrapping
        desc.layer.shadowRadius = 5.0
        desc.layer.shadowColor = UIColor.darkGray.cgColor
        self.desc.layer.masksToBounds = true

        DispatchQueue.main.async {
            self.card.roundCorners([.bottomLeft , .topLeft , .bottomRight], radius: 10 )
        }
        self.tableview.delegate = self
        self.tableview.dataSource = self
        self.tableview.estimatedRowHeight = 70
        self.tableview.rowHeight = UITableViewAutomaticDimension //+ 24
        
        
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
    
    @IBAction func Add(_ sender: Any) {
        if iduser != nil {
            
            let parameters: Parameters = [
                "id_user":  "\(self.iduser as! String)",
                "response":res_text.text as! String,
                "id_question": id_question
            ]
            
            Alamofire.request(AddResponse, method: .post, parameters: parameters).responseJSON {
                response in
                if response.result.isSuccess {
                    if let results = response.result.value as? NSDictionary{
                        self.error = results["error"] as? Bool
                        if (self.error == true){
                            print("error")
                        }else{
                            if (results["response"] != nil) {
                                let resp = Response(dictionary: results["response"] as! NSDictionary)
                                self.responses.append(resp!)
                                    self.tableview.reloadData()
                                self.res_text.text = ""
                                
                            }
                            
                        }
                    }
                    else
                        if response.result.isFailure {
                            print ("chiheb")
                    }
                }
            }
        }else{
            showToast(message: "انت زائر الرجاء انشاء حساب ")
        }
    }
    
    @IBAction func Refresh(_ sender: Any) {
        if #available(iOS 10.0, *) {
            tableview.refreshControl = refreshControl
        } else {
            tableview.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        GetClass()
        
    }
    
    @IBAction func Close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        //  self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension //+ 24
        // return 212
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return (self.responses.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        response = self.responses[indexPath.row]
        DispatchQueue.main.async {
            self.card.roundCorners([.bottomLeft , .topLeft , .bottomRight], radius: 10 )
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Responsecell")as! Responsecell
        cell.initialiser(question: response!)
        return cell
    }
    
    func GetClass(){
        let parameters: Parameters = [
            "id_question": id_question.description
        ]
        Alamofire.request(DetailQuestion, method: .post, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                self.progressView?.isHidden = true
                self.tableview.separatorStyle = UITableViewCellSeparatorStyle.singleLine
                if let results = response.result.value as? NSDictionary{
                    self.error = results["error"] as? Bool
                    if (self.error == true){
                        print("error")
                    }else{
                        if (results["Questions"] != nil) { self.question = Questions(dictionary: results["Questions"] as! NSDictionary)
                            self.responses = (self.question?.response)!
                            self.desc.text = self.question?.description
                            // loadimage(photo: photo, uri: (question.user?.photo!)!)
                            self.user_name.text = self.question?.user?.first_name
                            self.date.text = DateText(date: (self.question?.created_at!)!)
                            DispatchQueue.main.async {
                                self.tableview.reloadData()
                                self.refreshControl.endRefreshing()
                            }
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
