//
//  WormTabStripButton.swift
//  HalaChat
//
//  Created by pommestore on 17/11/2018.
//  Copyright © 2018 octadev. All rights reserved.
//

import Foundation
import UIKit
class WormTabStripButton: UILabel{
    
    
    var index:Int?
    var paddingToEachSide:CGFloat = 10
    var tabText:NSString?{
        didSet{
            let textSize:CGSize = tabText!.size(withAttributes: [NSAttributedString.Key.font: font])
            self.frame.size.width = textSize.width + paddingToEachSide + paddingToEachSide
            
            self.text = String(tabText!)
        }
    }
    //MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    convenience required init(key:String) {
        self.init(frame:CGRect.zero)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    
    
    
}
