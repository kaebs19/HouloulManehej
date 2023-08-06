//
//  ButtonCorner.swift
//  Manehej
//
//  Created by pommestore on 22/07/2018.
//  Copyright © 2018 octadev. All rights reserved.
//

import UIKit

class ButtonCorner: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 5
    
    override func awakeFromNib() {
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
    }
    
    
}
