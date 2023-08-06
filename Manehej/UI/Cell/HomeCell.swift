//
//  HomeCell.swift
//  Manehej
//
//  Created by pommestore on 08/07/2018.
//  Copyright © 2018 octadev. All rights reserved.
//

import UIKit

class HomeCell: UITableViewCell {

    @IBOutlet weak var h_lev: NSLayoutConstraint!
    @IBOutlet weak var schoollevels: UILabel!
    @IBOutlet weak var level_name: UILabel!
    @IBOutlet weak var photo_level: UIImageView!
    @IBOutlet weak var level_action: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none

        // Configure the view for the selected state
    }
    
    func initialiser(school : Schoollevels){
        schoollevels.text = school.level?.name
        level_name.text = school.name
        loadimage(photo: photo_level, uri: school.photo!)
        level_action.tag = school.id!
    }
}
