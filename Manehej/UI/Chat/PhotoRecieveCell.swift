//
//  PhotoRecieveCell.swift
//  HalaChat
//
//  Created by pommestore on 18/12/2018.
//  Copyright © 2018 octadev. All rights reserved.
//

import UIKit

class PhotoRecieveCell: UITableViewCell {

    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var image_v: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var photo: CircleImage!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none

        // Configure the view for the selected state
    }
    
    func  initialiser(message : Message){
        name.text = message.user?.first_name
        photo.loadImage(imageURL: (message.user?.photo)!, placeholder: UIImage(named: "user")!)
        image_v.loadImage(imageURL: (message.msg)!, placeholder: UIImage(named: "user")!)
        
    }
}
