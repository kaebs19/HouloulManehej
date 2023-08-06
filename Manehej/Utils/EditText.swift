//
//  EditText.swift
//  Manehej
//
//  Created by pommestore on 22/07/2018.
//  Copyright © 2018 octadev. All rights reserved.
//


import UIKit

class EditText: UITextField {
    
    
    let color = UIColor.darkGray

    override func awakeFromNib() {
        super.awakeFromNib()
        textAlignment = .right
        self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: color])

    }
    
    
    
}
