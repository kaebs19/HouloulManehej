//
//  Responsecell.swift
//  Manehej
//
//  Created by pommestore on 21/07/2018.
//  Copyright © 2018 octadev. All rights reserved.
//

import UIKit

class Responsecell: UITableViewCell {

    @IBOutlet weak var clas: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var photo: CircleImage!
    @IBOutlet weak var user_name: UILabel!
    @IBOutlet weak var card: UIView!
    @IBOutlet weak var desc: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        desc.lineBreakMode = .byWordWrapping
        desc.layer.shadowRadius = 5.0
        desc.layer.shadowColor = UIColor.darkGray.cgColor
        self.desc.layer.masksToBounds = true
        
        DispatchQueue.main.async {
            self.card.roundCorners([.bottomLeft , .topLeft , .bottomRight], radius: 10 )
        }

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
        // Configure the view for the selected state
    }
    
    func initialiser(question :Response){
        desc.text = question.response
        loadimage(photo: photo, uri: (question.user?.photo!)!)
        user_name.text = question.user?.first_name
        date.text = DateText(date: question.created_at!)

    }

}
