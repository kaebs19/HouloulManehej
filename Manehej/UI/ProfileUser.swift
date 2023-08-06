//
//  ProfileUser.swift
//  Manehej
//
//  Created by pommestore on 27/07/2018.
//  Copyright © 2018 octadev. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Firebase
import GoogleMobileAds

class ProfileUser: UIViewController ,GADRewardBasedVideoAdDelegate {
    
    public var error : Bool?
    let defaults = UserDefaults.standard
    var iduser : String?
    @IBOutlet weak var profilestack: UIStackView!{
        didSet{
            profilestack.isHidden = true
        }
    }
    
    @IBOutlet weak var logoutstack: UIStackView!{
        didSet{
            logoutstack.isHidden = true
        }
    }
    
   @IBOutlet weak var point: UIButton!{
       didSet{
           point.isHidden = true
       }
   }
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var photo: CircleImage!
    @IBOutlet weak var logout: UILabel!
    @IBOutlet weak var instagram: UILabel!
    @IBOutlet weak var twitter: UILabel!
    @IBOutlet weak var share: UILabel!
    @IBOutlet weak var about: UILabel!
    @IBOutlet weak var profile: UILabel!
    @IBOutlet weak var rating: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        iduser = defaults.string(forKey: "user_uid")
        if iduser != nil{
            LoadData()
        }else{
            showToast(message: "انت زائر الرجاء انشاء حساب ")
        }
        
        let tap = UITapGestureRecognizer(target: self,action: #selector(Intes))
        self.instagram.isUserInteractionEnabled = true
        self.instagram.addGestureRecognizer(tap)
        
        let tap1 = UITapGestureRecognizer(target: self,action: #selector(AboutApp))
        self.about.isUserInteractionEnabled = true
        self.about.addGestureRecognizer(tap1)
        
        let tap2 = UITapGestureRecognizer(target: self,action: #selector(ShowProfile))
        self.profile.isUserInteractionEnabled = true
        self.profile.addGestureRecognizer(tap2)
        
        let tap3 = UITapGestureRecognizer(target: self,action: #selector(Twit))
        self.twitter.isUserInteractionEnabled = true
        self.twitter.addGestureRecognizer(tap3)
        
        let tap4 = UITapGestureRecognizer(target: self,action: #selector(Share))
        self.share.isUserInteractionEnabled = true
        self.share.addGestureRecognizer(tap4)
        
        let tap5 = UITapGestureRecognizer(target: self,action: #selector(Logout))
        self.logout.isUserInteractionEnabled = true
        self.logout.addGestureRecognizer(tap5)
        
        
        let tap6 = UITapGestureRecognizer(target: self,action: #selector(Rating))
        self.rating.isUserInteractionEnabled = true
        self.rating.addGestureRecognizer(tap6)
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Point(_ sender: Any) {
        GADRewardBasedVideoAd.sharedInstance().delegate = self
        GADRewardBasedVideoAd.sharedInstance().load(GADRequest(),
                                                    withAdUnitID: "ca-app-pub-8219247197168750/6376490991")
        
    }
    
    @objc func Intes(){
        let instagramHooks = "instagram://user?username=hala.chat"
        let instagramUrl = NSURL(string: instagramHooks)
        if UIApplication.shared.canOpenURL(instagramUrl! as URL) {
            UIApplication.shared.openURL(instagramUrl! as URL)
        } else {
            //redirect to safari because the user doesn't have Instagram
            UIApplication.shared.openURL(NSURL(string: "https://www.instagram.com/hala.chat")! as URL )
        }
        
    }
    
    @objc func Twit(){
        //twitter.com/Hala_chat
        
        let instagramHooks = "twitter://user?screen_name=B_c_Arab"
        let instagramUrl = NSURL(string: instagramHooks)
        if UIApplication.shared.canOpenURL(instagramUrl! as URL) {
            UIApplication.shared.openURL(instagramUrl! as URL)
        } else {
            //redirect to safari because the user doesn't have Instagram
            UIApplication.shared.openURL(NSURL(string: "https://twitter.com/B_c_Arab")! as URL )
        }
    }
    
    @objc func Share(){
        let text = "حل-المناهج-الدراسية-السعودية"
        let image = UIImage(named: "AppIcon")
        let myWebsite = NSURL(string:"https://apps.apple.com/us/app/id1378565817")
        let shareAll = [text , image! , myWebsite] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    
    @objc func AboutApp(){
        let VC1 = self.storyboard?.instantiateViewController(withIdentifier: "about")
        self.show(VC1!, sender: self)
        
    }
    
    
    @objc func ShowProfile(){
        if iduser != nil{
            
            let VC1 = self.storyboard?.instantiateViewController(withIdentifier: "EditProfil")
            self.show(VC1!, sender: self)
        }else{
            showToast(message: "انت زائر الرجاء انشاء حساب ")
        }
    }
    @objc func Rating(){
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        } else {
            // Fallback on earlier versions
        }
    }
    
    @objc func Logout(){
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
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
                            didRewardUserWith reward: GADAdReward) {
        print("Reward received with currency: \(reward.type), amount \(reward.amount).")
    }
    
    func rewardBasedVideoAdDidReceive(_ rewardBasedVideoAd:GADRewardBasedVideoAd) {
        print("Reward based video ad is received.")
        if GADRewardBasedVideoAd.sharedInstance().isReady == true {
            GADRewardBasedVideoAd.sharedInstance().present(fromRootViewController: self)
        }
        
    }
    
    func rewardBasedVideoAdDidOpen(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Opened reward based video ad.")
    }
    
    func rewardBasedVideoAdDidStartPlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad started playing.")
    }
    
    func rewardBasedVideoAdDidCompletePlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad has completed.")
        if iduser != nil {
            FNUpdateScore()
        }else{
            showToast(message: "انت زائر الرجاء انشاء حساب ")
        }
    }
    
    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad is closed.")
    }
    
    func rewardBasedVideoAdWillLeaveApplication(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad will leave application.")
    }
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
                            didFailToLoadWithError error: Error) {
        print("Reward based video ad failed to load.")
    }
    
    
    func LoadData() {
       /* if iduser != nil
        {
            let parameters: Parameters = [
                "id_user": iduser?.description as! String
            ]
            Alamofire.request(ProfileUSer, method: .post, parameters: parameters).responseJSON {
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
        }else{
            showToast(message: "انت زائر الرجاء انشاء حساب ")
        }*/
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
    
    
    func FNUpdateScore(){
        let url = UpdateScore + iduser! as! String
        Alamofire.request(url, method: .get).responseJSON {
            response in
            if response.result.isSuccess {
                if let results = response.result.value as? NSDictionary{
                    self.error = results["error"] as? Bool
                    if (self.error == true){
                        print("error")
                    }else{
                        print(results)
                        if (results["user"] != nil) {
                            self.showToast(message: "تم اضافة نقاط الى رصيدك")
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
}
