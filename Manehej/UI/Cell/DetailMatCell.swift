//
//  DetailMatCell.swift
//  Manehej
//
//  Created by pommestore on 09/07/2018.
//  Copyright © 2018 octadev. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class DetailMatCell: UITableViewCell ,UITableViewDelegate ,UITableViewDataSource {
    var iduser : String?
    var drill : Array<Drill>?
    var book :Drill?
    var error: Bool?
    let defaults = UserDefaults.standard
    var context : UIViewController?
    @IBOutlet weak var readBook: UIButton!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var sc_name: UILabel!
    @IBOutlet weak var book_name: UILabel!
    @IBOutlet weak var fav: UIButton!
    @IBOutlet weak var photo: UIImageView!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if drill == nil {
            return 0
        }else{
            return (self.drill?.count)!
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BooksCell")as! BooksCell
        book = drill?[indexPath.row]
        cell.initialiser(book : book!)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let book = drill?[indexPath.row]
        let VC1 = context?.storyboard!.instantiateViewController(withIdentifier: "DocumentController") as! DocumentController
        VC1.url = (book?.url)!
        VC1.name = (book?.title)!
        VC1.id = (book?.id?.description)!
        context?.show(VC1, sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        iduser = defaults.string(forKey: "user_uid")
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
        
        // Configure the view for the selected state
    }
    
    func initialiser(book : Book){
        tableview.delegate = self
        tableview.dataSource = self
        drill = book.drill
        let size = drill!.count
        
        tableview.reloadData()
        sc_name.text = book.nclass
        book_name.text = book.title
        fav.tag = book.id!
        fav.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        if book.iSMyFavorite {
            let origImage = UIImage(named: "23911")
            let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
            fav.setImage(tintedImage, for: .normal)
            fav.tintColor = .gray
        }
        loadimage(photo: photo, uri: book.photo!)
        
    }
    
    
    
    @objc func buttonAction(sender: UIButton!) {
        let parameters: Parameters = [
            "id_user": iduser as! String,
            "id_object": sender.tag.description as! String,
            "Type_object": "book"
        ]
        Alamofire.request(Favorit, method: .post, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                if let results = response.result.value as? NSDictionary{
                    self.error = results["error"] as? Bool
                    if (self.error == true){
                        print("error")
                    }else{
                        print( results["message"])
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
