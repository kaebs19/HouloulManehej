//
//  MainController.swift
//  Manehej
//
//  Created by pommestore on 07/07/2018.
//  Copyright © 2018 octadev. All rights reserved.
//

import UIKit

class MainController: UITabBarController {
    @IBOutlet weak var tabbar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedIndex = 2
        tabBar.inActiveTintColor()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewDidAppear(_ animated: Bool) {
        //  self.selectedIndex = 3
    }
}
extension UIViewController {
    
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 100, y: self.view.frame.size.height-100, width: 200, height: 35))
        toastLabel.backgroundColor = colorWithHexString(hex: "#C2185B").withAlphaComponent(0.9)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 3.0, delay: 0.3, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    } }

extension UIView{
    func loadimage(photo: UIImageView , uri : String ){
        let url:URL?
        if uri.contains("http")
        {
            url = URL(string: uri)
        }else{
            url = URL(string: ResourceUrl + uri)
        }
        if url != nil {
            let task = URLSession.shared.dataTask(with: url!) {responseData,response,error in
                if error == nil{
                    if let data = responseData {
                        
                        DispatchQueue.main.async {
                            photo.image = UIImage(data: data)
                        }
                        
                    }else {
                        print("no data")
                    }
                }else{
                }
                
            }
       
        
        task.resume()
             }
    }
    
    func createDirectory(){
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("ManehejDirectory")
        if !fileManager.fileExists(atPath: paths){
            try! fileManager.createDirectory(atPath: paths, withIntermediateDirectories: true, attributes: nil)
        }else{
            print("Already dictionary created.")
        }
    }
    
}
extension UITabBar{
    func inActiveTintColor() {
        if let items = items{
            for item in items{
                item.image =  item.image?.withRenderingMode(.alwaysOriginal)
                //  item.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor.black], for: .normal)
                //   item.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor.white], for: .selected)
            }
        }
    }
}
