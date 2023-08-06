//
//  TextCell.swift
//  HalaChat
//
//  Created by pommestore on 15/12/2018.
//  Copyright © 2018 octadev. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AlamofireImage


class TextCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var bac: UIView!
    @IBOutlet weak var mess: UILabel!
    @IBOutlet weak var status: UIImageView!
    @IBOutlet weak var photo: CircleImage!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        DispatchQueue.main.async {
            self.bac.roundCorners([.bottomLeft , .topLeft , .bottomRight], radius: 15 )
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
        
        // Configure the view for the selected state
    }
    
    func  initialiser(message : Message){
        name.text = message.user?.first_name
        self.mess.lineBreakMode = .byWordWrapping
        self.mess.text =   (message.msg?.removingPercentEncoding)?.replacingOccurrences(of: "+", with: " ")
        photo.loadImage(imageURL: (message.user?.photo)!, placeholder: UIImage(named: "user")!)
    }
   
}
extension UIImageView {
    func loadImage(imageURL:String, placeholder :UIImage){
     //   self.contentMode = UIView.ContentMode.scaleAspectFill;
        self.image = placeholder
        if(imageURL != ""){
            var url = ""
            if(imageURL.contains("http")){
                url =  imageURL
            }else{
                url = ResourceUrl  + imageURL
            }
            Alamofire.request(url ,method: .get).responseImage() { response in
                if let image = response.result.value {
                    self.image = image
                }
            }
        }
    }
}
