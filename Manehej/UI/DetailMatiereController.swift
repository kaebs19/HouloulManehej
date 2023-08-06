//
//  DetailMatiereController.swift
//  Manehej
//
//  Created by pommestore on 09/07/2018.
//  Copyright © 2018 octadev. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView

@available(iOS 11.0, *)
@available(iOS 11.0, *)
class DetailMatiereController: UIViewController ,UITableViewDelegate ,UITableViewDataSource {
    public var books : [Book] = []
    public var book : Book? = nil
    public var error : Bool?
    var progressView : ProgressBar?
    let defaults = UserDefaults.standard
    var iduser : String?
    var idmatiere : String?
    let refreshControl = UIRefreshControl()
    @IBOutlet weak var titre: UILabel!
    var name: String = ""
    var semester = ""
    @IBOutlet weak var tableview: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.delegate = self
        tableview.dataSource = self
        titre.text = name
        iduser = defaults.string(forKey: "user_uid")
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
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
        Detail()
    }
    
    @objc private func refreshWeatherData(_ sender: Any) {
        Detail()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Close(_ sender: Any) {
         self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        return (self.books.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        book = books[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailMatCell")as! DetailMatCell
        cell.initialiser(book: book!)
        cell.readBook.tag = indexPath.row
        cell.context = self
        cell.readBook.addTarget(self, action: #selector(ReadBook), for: .touchUpInside)
        return cell
    }
    
    
    @objc func ReadBook(sender: UIButton!) {
        let book = books[sender.tag]
        
        let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "DocumentController") as! DocumentController
        VC1.url = (book.url)!
        VC1.name = (book.title)!
        VC1.id = (book.id?.description)!
        VC1.book = book
        //   let navController = UINavigationController(rootViewController: VC1)
        //  self.present(VC1, animated:true, completion: nil)
        self.show(VC1, sender: self)
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let b = books[indexPath.row]
        let size = b.drill?.count
        if size == 0
        {
            return 130
        }
        if size == 1
        {
            return 250
        }
        if size == 2
        {
            return 320
        }
        
        return 394
    }
    
    
    func Detail() {
        if iduser == nil{
        iduser = "2"
        }
        let parameters: Parameters = [
            "id_matiere": idmatiere as! String,
            "id_user" : iduser?.description as! String,
            "semester" : semester
            ]
            print(parameters)
        
        Alamofire.request(ListeBook, method: .post, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                self.progressView?.isHidden = true
                self.tableview.separatorStyle = UITableViewCellSeparatorStyle.singleLine
                if let results = response.result.value as? NSDictionary{
                    self.error = results["error"] as? Bool
                    if (self.error == true){
                        print("error")
                    }else{
                        if (results["book"] != nil) {
                            self.books = Book.modelsFromDictionaryArray(array: results["book"] as! NSArray)
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
