//
//  TextRecieveCell.swift
//  HalaChat
//
//  Created by pommestore on 17/12/2018.
//  Copyright © 2018 octadev. All rights reserved.
//

import UIKit

class TextRecieveCell: UITableViewCell {

    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var photo: CircleImage!
    @IBOutlet weak var status: UIImageView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var bac: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        DispatchQueue.main.async {
            self.bac.roundCorners([.bottomLeft  , .bottomRight , .topRight], radius: 15 )
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none

        // Configure the view for the selected state
    }
    
    func  initialiser(message : Message){
        name.text = message.user?.first_name
        self.desc.lineBreakMode = .byWordWrapping
        self.desc.text =   (message.msg?.removingPercentEncoding)?.replacingOccurrences(of: "+", with: " ")
        photo.loadImage(imageURL: (message.user?.photo)!, placeholder: UIImage(named: "user")!)
        
    }
 
}
