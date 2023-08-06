//
//  FavoritCell.swift
//  Manehej
//
//  Created by pommestore on 08/07/2018.
//  Copyright © 2018 octadev. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class FavoritCell: UITableViewCell {
    var iduser : String?
    let defaults = UserDefaults.standard
    var error: Bool?
    @IBOutlet weak var favorite: UIButton!
    var context : UIViewController?
    @IBOutlet weak var level: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var photo: UIImageView!
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
    
    @IBAction func FavoritAction(_ sender: UIButton) {
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
                        if (results["message"]as! String == "favorit added")
                        {
                            self.context?.showToast(message: "تم اضافة الكتاب الى قائمتك المفضلة")
                        }else{
                            self.context?.showToast(message: "تم ازالة الكتاب من قائمتك المفضلة")
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
    
    func initialiser(book :Book){
        name.text = book.title
        level.text = book.matiere
        favorite.tag = book.id!
        loadimage(photo: photo, uri: book.photo!)
        
    }
    
    
}
