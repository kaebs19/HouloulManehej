//
//  ProgressBar.swift
//  Manehej
//
//  Created by pommestore on 19/07/2018.
//  Copyright © 2018 octadev. All rights reserved.
//

import UIKit

class ProgressBar: UIView ,CAAnimationDelegate {
    
    let circularLayer = CAShapeLayer()
    let googleColors = [
        UIColor(red:0.282, green:0.522, blue:0.929, alpha:1),
        UIColor(red:0.859, green:0.196, blue:0.212, alpha:1),
        UIColor(red:0.957, green:0.761, blue:0.051, alpha:1),
        UIColor(red:0.235, green:0.729, blue:0.329, alpha:1)
    ]
    
    let inAnimation: CAAnimation = {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = 1.0
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        
        return animation
    }()
    
    let outAnimation: CAAnimation = {
        let animation = CABasicAnimation(keyPath: "strokeStart")
        animation.beginTime = 0.5
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = 1.0
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        return animation
    }()
    
    let rotationAnimation: CAAnimation = {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0.0
        animation.toValue = 2 * M_PI
        animation.duration = 2.0
        animation.repeatCount = MAXFLOAT
        
        return animation
    }()
    
    var colorIndex : Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        circularLayer.lineWidth = 4.0
        circularLayer.fillColor = nil
        layer.addSublayer(circularLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2 - circularLayer.lineWidth / 2
        let arcPath = UIBezierPath(arcCenter: CGPoint.zero, radius: radius, startAngle: CGFloat(M_PI_2), endAngle: CGFloat(M_PI_2 + (2 * M_PI)), clockwise: true)
        
        circularLayer.position = center
        circularLayer.path = arcPath.cgPath
        
        animateProgressView()
        circularLayer.add(rotationAnimation, forKey: "rotateAnimation")
    }
    
    func animateProgressView() {
        circularLayer.removeAnimation(forKey: "strokeAnimation")
        
        circularLayer.strokeColor = googleColors[colorIndex].cgColor
        
        let strokeAnimationGroup = CAAnimationGroup()
        strokeAnimationGroup.duration = 1.0 + outAnimation.beginTime
        strokeAnimationGroup.repeatCount = 1
        strokeAnimationGroup.animations = [inAnimation, outAnimation]
        strokeAnimationGroup.delegate = (self as CAAnimationDelegate)
        
        circularLayer.add(strokeAnimationGroup, forKey: "strokeAnimation")
        
        colorIndex += 1;
        colorIndex = colorIndex % googleColors.count;
    }
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if(flag) {
            animateProgressView()
        }
    }
    
}
