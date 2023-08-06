//
//  QuestionController.swift
//  Manehej
//
//  Created by pommestore on 08/07/2018.
//  Copyright © 2018 octadev. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class QuestionController: UIViewController , UITableViewDataSource , UITableViewDelegate ,UITextFieldDelegate{
    
    
    public var questions : [Questions] = []
    public var question : Questions? = nil
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
        
        if let iduser = defaults.string(forKey: "user_uid") {
        }else{
            iduser = "2"
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
        return (questions.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.question = self.questions[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell")as! QuestionCell
        cell.initialiser(question :self.question!)
        let tap5 = UITapGestureRecognizer(target: self,action: #selector(Detail(tapGestureRecognizer:)))
        cell.card.isUserInteractionEnabled = true
        cell.card.addGestureRecognizer(tap5)
        return cell

    }
    
    @objc func Detail(tapGestureRecognizer: UITapGestureRecognizer){
        let VC1 = self.storyboard?.instantiateViewController(withIdentifier: "ResponseController")as! ResponseController
        VC1.id_question = (tapGestureRecognizer.view?.tag.description)!
        let Nav = UINavigationController(rootViewController: VC1)
        Nav.modalPresentationStyle = .fullScreen

        self.present(Nav, animated: true, completion: nil)
    }
    
    func GetClass(){
        let parameters: Parameters = [
            "id_user": iduser
        ]
        Alamofire.request(ListeQuestion, method: .post, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                self.progressView?.isHidden = true
                self.tableview.separatorStyle = UITableViewCellSeparatorStyle.singleLine
                if let results = response.result.value as? NSDictionary{
                    self.error = results["error"] as? Bool
                    if (self.error == true){
                        print("error")
                    }else{
                        if (results["Questions"] != nil) { self.questions = Questions.modelsFromDictionaryArray(array: results["Questions"] as! NSArray)
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
