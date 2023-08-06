//
//  SignUpController.swift
//  Manehej
//
//  Created by pommestore on 23/07/2018.
//  Copyright © 2018 octadev. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import UIView_Shake

class SignUpController: UIViewController {
    
    @IBOutlet weak var name: EditText!
    @IBOutlet weak var school: EditText!
    @IBOutlet weak var level: EditText!
    @IBOutlet weak var mail: EditText!
    @IBOutlet weak var password: EditText!
    @IBOutlet weak var progress: UIActivityIndicatorView!
    @IBOutlet weak var done: ButtonCorner!
    
    var verif:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Close(_ sender: Any) {
            self.dismiss(animated: true , completion: nil)
    }
    
    
    @IBAction func Inscript(_ sender: Any) {
        if name.text == ""{
            verif = false
            name.shake(10, withDelta: 5.0)
        }else
            if school.text == ""{
                verif = false
                school.shake(10, withDelta: 5.0)
            }
            else
                if level.text == ""{
                    verif = false
                    level.shake(10, withDelta: 5.0)
                }
                else
                    if mail.text == ""{
                        verif = false
                        mail.shake(10, withDelta: 5.0)
                    }else
                        if password.text == ""{
                            verif = false
                            password.shake(10, withDelta: 5.0)
                        }else
                            if verif{
                                done.isHidden = true
                                progress.alpha = 1
                                
                                
                                let parameters: Parameters = [
                                    "email": mail.text as! String,
                                    "password": password.text as! String,
                                    "first_name": name.text as! String,
                                    "class": level.text as! String,
                                    "last_name": "manehej"
                                ]
                                self.progress.alpha = 1
                                Alamofire.request(CreateUser  , method: .post , parameters: parameters ).responseJSON {
                                    response in
                                    if response.result.isSuccess {
                                        
                                        if let results = response.result.value as? NSDictionary{
                                            if (results["user"] != nil) {
                                                let  person = User (dictionary: results["user"]as Any as! NSDictionary)!
                                                let defaults = UserDefaults.standard
                                                defaults.set(person.id, forKey: "user_uid")
                                                defaults.set(person.first_name, forKey: "user_name")
                                                defaults.set(person.photo, forKey: "user_photo")
                                                
                                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                                let controller = storyboard.instantiateViewController(withIdentifier: "MainController")
                                                self.present(controller, animated: true, completion: nil)
                                                
                                            }else{
                                                self.showToast(message: "تأكد من معلومات الدخول")
                                                self.done.isHidden = false
                                                self.progress.alpha = 0
                                            }
                                        }
                                    }
                                    else
                                        if response.result.isFailure {
                                            self.done.isHidden = false
                                            self.progress.alpha = 0
                                    }
                                }
        }
        
        
    }
    
}
