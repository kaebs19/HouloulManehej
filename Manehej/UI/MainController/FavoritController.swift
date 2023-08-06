//
//  FavoritController.swift
//  Manehej
//
//  Created by pommestore on 08/07/2018.
//  Copyright © 2018 octadev. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import GoogleMobileAds


class FavoritController: UIViewController  , UITableViewDataSource , UITableViewDelegate ,GADBannerViewDelegate{
    
    
    public var books : [Book] = []
    public var book : Book? = nil
    public var error : Bool?
    var progressView : ProgressBar?
    let defaults = UserDefaults.standard
    var iduser : String?
    
    let refreshControl = UIRefreshControl()
    @IBOutlet weak var bannerView: GADBannerView!
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
        if iduser != nil {
            GetClass()
        }else{
            showToast(message: "انت زائر الرجاء انشاء حساب ")
        }
        
        //realise ads id
        //bannerView.adUnitID = "ca-app-pub-8219247197168750/1371252929"
        //test code ads id
        bannerView.adUnitID = bannerid
        bannerView.rootViewController = self
        bannerView.load(GADRequest())

    }
    
    @objc private func refreshWeatherData(_ sender: Any) {
        GetClass()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (books.count)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let book = books[indexPath.row]
        
        let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "DocumentController") as! DocumentController
        VC1.url = (book.url)!
        VC1.name = (book.title)!
        VC1.id = (book.id?.description)!
        VC1.book = book
        self.show(VC1, sender: self)

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.book = books[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritCell")as! FavoritCell
        cell.initialiser(book : self.book!)
        cell.context = self
        return cell
    }
    
    func GetClass(){
        let parameters: Parameters = [
            "id_user": iduser?.description as! String
        ]
        print(parameters)
        Alamofire.request(FavoritBookUser, method: .post, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                self.progressView?.isHidden = true
                self.tableview.separatorStyle = UITableViewCellSeparatorStyle.singleLine
                if let results = response.result.value as? NSDictionary{
                    self.error = results["error"] as? Bool
                    if (self.error == true){
                        print("error")
                    }else{
                        if (results["book"] != nil) { self.books = Book.modelsFromDictionaryArray(array: results["book"] as! NSArray)
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
