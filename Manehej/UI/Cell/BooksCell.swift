//
//  BooksCell.swift
//  Manehej
//
//  Created by pommestore on 09/07/2018.
//  Copyright © 2018 octadev. All rights reserved.
//

import UIKit

class BooksCell: UITableViewCell {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none

        // Configure the view for the selected state
    }
    func initialiser(book :Drill){
        name.text = book.title
        loadimage(photo: photo, uri: book.photo!)
    }
}
