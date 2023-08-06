//
//  CircleImage.swift
//  Manehej
//
//  Created by pommestore on 08/07/2018.
//  Copyright © 2018 octadev. All rights reserved.
//

import UIKit

@IBDesignable
class CircleImage: UIImageView {
    @IBInspectable
    var cornerRadius: CGFloat = 30
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
    }
}
