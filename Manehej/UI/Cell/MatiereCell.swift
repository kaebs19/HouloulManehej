//
//  MatiereCell.swift
//  Manehej
//
//  Created by pommestore on 09/07/2018.
//  Copyright © 2018 octadev. All rights reserved.
//

import UIKit

class MatiereCell: UITableViewCell {
    
    @IBOutlet weak var photo: CircleImage!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var course: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
        
        // Configure the view for the selected state
    }
    
    func initialiser(matier :Matiere){
        loadimage(photo: self.photo, uri: (matier.photo!))
        name.text = matier.name
        course.text = ""
    }
    
}
