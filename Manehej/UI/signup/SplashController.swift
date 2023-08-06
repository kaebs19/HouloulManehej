//
//  SplashController.swift
//  Manehej
//
//  Created by pommestore on 07/07/2018.
//  Copyright © 2018 octadev. All rights reserved.
//

import UIKit

class SplashController: UIViewController {
    
    
    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imie = UIDevice.current.identifierForVendor?.description as! String

        let defaults = UserDefaults.standard
        defaults.set(imie.description, forKey: "user_uid")
        defaults.set(randomString(length: 8) , forKey: "user_name")

        
        let iduser = defaults.string(forKey: "user_uid")
        let user_name = defaults.string(forKey: "user_name")
        print("randomString", iduser)
        print("randomString", user_name)

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                // ...and once it finishes we flash the HUD for a second.
                if(iduser  != "" ){
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "MainController")
                    self.present(controller, animated: true, completion: nil)
                }else{
                    /*let storyboard = UIStoryboard(name: "Main", bundle: nil)
                     let controller = storyboard.instantiateViewController(withIdentifier: "LoginController")
                     self.present(controller, animated: true, completion: nil)
                     */
                    let defaults = UserDefaults.standard
                    defaults.set("زائر", forKey: "user_name")
                    defaults.set("", forKey: "user_photo")
                    defaults.set(nil, forKey: "user_uid")

                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "MainController")
                    self.present(controller, animated: true, completion: nil)
                    
                }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
