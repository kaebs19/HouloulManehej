//
//  EditProfil.swift
//  Manehej
//
//  Created by pommestore on 28/07/2018.
//  Copyright © 2018 octadev. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SCLAlertView
import Firebase


class EditProfil: UIViewController ,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    let defaults = UserDefaults.standard
    var iduser : String?
    
    @IBOutlet weak var photo: CircleImage!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var last_name: UITextField!
    @IBOutlet weak var level: UITextField!
    @IBOutlet weak var about: UITextField!
    @IBOutlet weak var score: UILabel!
    
    var error : Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        iduser = defaults.string(forKey: "user_uid")
        
        LoadData()
        
        let tap = UITapGestureRecognizer(target: self,action: #selector(SelectPhoto))
        photo.isUserInteractionEnabled = true
        photo.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Close(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func DeleteAccountAction(_ sender: Any) {
        if iduser != nil
        {
            let parameters: Parameters = [
                "id_user": iduser?.description as! String
            ]
            Alamofire.request(DeleteUser, method: .post, parameters: parameters).responseJSON {
                response in
                if response.result.isSuccess {
                    if let results = response.result.value as? NSDictionary{
                        self.error = results["error"] as? Bool
                        if (self.error == true){
                            print("error")
                        }else{
                            UserDefaults.standard.removeObject(forKey: "user_uid")
                            UserDefaults.standard.removeObject(forKey: "user_name")
                            UserDefaults.standard.removeObject(forKey: "user_photo")
                            let firebaseAuth = FIRAuth.auth()
                            do {
                                try firebaseAuth?.signOut()
                            } catch let signOutError as NSError {
                                print ("Error signing out: %@", signOutError)
                            }
                            // [END signout]
                            
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let controller = storyboard.instantiateViewController(withIdentifier: "LoginController")
                            self.present(controller, animated: true, completion: nil)
                        }
                    }
                }
                else
                    if response.result.isFailure {
                        print ("chiheb")
                }
            }
        }else{
            showToast(message: "انت زائر الرجاء انشاء حساب ")
        }
    }
    

    @objc func SelectPhoto(_ sender: Any){
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType  = .photoLibrary
        present(controller,animated: true ,completion: nil)
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage]as! UIImage
        self.photo.image = image //(image, for: .normal)
        dismiss(animated: true, completion: nil)
    }

    func LoadData() {
        let parameters: Parameters = [
            "id_user": iduser as! String
        ]
        
        Alamofire.request(ProfileUSer , method: .post, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                if let results = response.result.value as? NSDictionary{
                    self.error = results["error"] as? Bool
                    if (self.error == true){
                        print("error")
                    }else{
                        print(results)
                        if (results["user"] != nil) {
                            let  person = User (dictionary: results["user"]as Any as! NSDictionary)!
                            self.name.text = person.first_name
                            self.last_name.text = person.last_name
                            self.level.text = person.clas
                            self.about.text = person.about_user
                            self.score.text = person.score
                            self.loadimageA(photo: self.photo , uri : person.photo! )
                            
                        }
                    }
                }
            }
            else
                if response.result.isFailure {
                    print ("chiheb")
            }
        }
    }
    func loadimageA(photo: UIImageView , uri : String ){
        let url:URL?
        if uri.contains("http")
        {
            url = URL(string: uri)
        }else{
            url = URL(string: ResourceUrl + uri)
        }
        if uri != "" {
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
        }else{
            photo.image = UIImage(named: "user")
        }
    }
    
    
    @IBAction func Done(_ sender: Any) {
    SendData()
        
    }
    
    func SendData(){
        let parameters: Parameters = [
            "id_user": iduser as! String ,
            "first_name" : self.name.text as! String,
            "last_name" : self.last_name.text as! String,
            "about_user": self.about.text as! String ,
            "class": self.level.text as! String
        ]
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        
        let alert = SCLAlertView(appearance: appearance).showWait("Download", subTitle: "Processing...", closeButtonTitle: nil, timeout: nil, colorStyle: nil, colorTextButton: 0xFFFFFF, circleIconImage: nil, animationStyle: SCLAnimationStyle.topToBottom)
        
        Alamofire.upload(multipartFormData:
            {
                (multipartFormData) in
                multipartFormData.append(UIImageJPEGRepresentation(self.photo.image!, 0.1)!, withName: "photo", fileName: "file.jpeg", mimeType: "image/jpeg")
                for (key, value) in parameters
                {
                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
        }, to:updateUser,headers:nil)
        { (result) in
            switch result {
            case .success(let upload,_,_ ):
                upload.uploadProgress(closure: { (progress) in
                    print(progress)
                })
                upload.responseJSON
                    { response in
                        /* if (result["user"] != nil) {
                         let  person = User (dictionary: result["user"]as Any as! NSDictionary)!
                         let defaults = UserDefaults.standard
                         defaults.set(person.id, forKey: "user_uid")
                         defaults.set(person.name, forKey: "user_name")
                         defaults.set(person.picture, forKey: "user_photo")
                         
                         }
                         */
                        alert.close()
                }
            case .failure(let encCreateBookodingError):
                break
            }
            
            
        }

    }
}
