//
//  MatierePager.swift
//  Manehej
//
//  Created by pommestore on 27/12/2018.
//  Copyright © 2018 octadev. All rights reserved.
//

import UIKit

class MatierePager: UIViewController , WormTabStripDelegate {
    
    var tabs:[UIViewController] = []
    let numberOfTabs = 2
    var id_mat = ""
    
    @IBOutlet weak var container: UIView!
    let color = colorWithHexString(hex : "#1A8AC8")
    let color1 = colorWithHexString(hex : "#AEB8C0")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabs()
        setUpViewPager()
        self.navigationItem.setHidesBackButton(true, animated:false);
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //   self.tabBarController?.navigationItem.hidesBackButton = true
    }
    
    @IBAction func Close(_ sender: Any) {
      //  self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    func setUpTabs(){
        for i in 1...numberOfTabs {
            if (i == 1) {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MatiereController") as! MatiereController
                vc.context = self
                vc.id_mat = id_mat
                vc.semester = "2"
                tabs.append(vc)
            }
            else
            {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MatiereController") as! MatiereController
                vc.context = self
                vc.id_mat = id_mat
                tabs.append(vc)
            }
        }
    }
    
    func setUpViewPager(){
        let frame =  CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.container.frame.size.height - 60)
        let viewPager:WormTabStrip = WormTabStrip(frame: frame)
        self.container.addSubview(viewPager)
        viewPager.delegate = self
        viewPager.eyStyle.topScrollViewBackgroundColor = .white
        viewPager.eyStyle.wormStyel = .LINE
        viewPager.eyStyle.isWormEnable = false
        viewPager.eyStyle.WormColor = color
        viewPager.eyStyle.dividerBackgroundColor = .white
        viewPager.eyStyle.tabItemSelectedColor = color
        viewPager.eyStyle.tabItemDefaultColor = color1
        viewPager.eyStyle.spacingBetweenTabs = 1
        viewPager.currentTabIndex = 1
        viewPager.eyStyle.kPaddingOfIndicator = 0
        viewPager.eyStyle.tabItemDefaultFont   = UIFont.systemFont(ofSize: 15)
        viewPager.eyStyle.tabItemSelectedFont   = UIFont.systemFont(ofSize: 15)
        viewPager.buildUI()
    }
    
    func WTSNumberOfTabs() -> Int {
        return numberOfTabs
    }
    
    func WTSTitleForTab(index: Int) -> String {
        if(index==1){
            return " الفصل الأول "
        }
        if(index==0){
            return " الفصل الثاني والثالث "
        }
        return "  "
        
    }
    
    func WTSViewOfTab(index: Int) -> UIView {
        let view = tabs[index]
        return view.view
    }
    
    func WTSReachedLeftEdge(panParam: UIPanGestureRecognizer) {
        
    }
    
    func WTSReachedRightEdge(panParam: UIPanGestureRecognizer) {
        
    }
    
    
    func setTitle(title:String, subtitle:String) -> UIView {
        let titleLabel = UILabel(frame: CGRect(x:0, y:-5, width:0, height:0))
        
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.textColor = UIColor.gray
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        titleLabel.text = title
        titleLabel.sizeToFit()
        
        let subtitleLabel = UILabel(frame: CGRect(x:0, y:18, width:0, height:0))
        subtitleLabel.backgroundColor = UIColor.clear
        subtitleLabel.textColor = colorWithHexString(hex: "B8E986")
        subtitleLabel.font = UIFont.systemFont(ofSize: 12)
        subtitleLabel.text = subtitle
        subtitleLabel.sizeToFit()
        
        let titleView = UIView(frame: CGRect(x:0, y:0, width:max(titleLabel.frame.size.width, subtitleLabel.frame.size.width), height:30))
        titleView.addSubview(titleLabel)
        titleView.addSubview(subtitleLabel)
        
        let widthDiff = subtitleLabel.frame.size.width - titleLabel.frame.size.width
        
        if widthDiff > 0 {
            var frame = titleLabel.frame
            frame.origin.x = widthDiff / 2
            titleLabel.frame = frame.integral
        } else {
            var frame = subtitleLabel.frame
            frame.origin.x = abs(widthDiff) / 2
            titleLabel.frame = frame.integral
        }
        
        return titleView
    }
    
}
