//
//  NotificationCell.swift
//  Manehej
//
//  Created by pommestore on 24/07/2018.
//  Copyright © 2018 octadev. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {
    
    @IBOutlet weak var width_: NSLayoutConstraint!
    @IBOutlet weak var delete: UIButton!
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
    func initialiser(notification : Notification){
        desc.text = (notification.user?.first_name)! + "قام باضافة رد على سوالك " + (notification.question?.description)!
        delete.tag = notification.id!
    }
    
    @IBAction func FN_Delete(_ sender: UIButton) {
    
    }
}
