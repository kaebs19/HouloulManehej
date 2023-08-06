//
//  DocumentController.swift
//  Manehej
//
//  Created by pommestore on 21/07/2018.
//  Copyright © 2018 octadev. All rights reserved.
//

import UIKit
import GoogleMobileAds
import SwiftyJSON
import Alamofire
import JGProgressHUD
import TTGSnackbar
import WebKit


class DocumentController: UIViewController ,GADBannerViewDelegate ,GADInterstitialDelegate {
    
    @IBOutlet weak var fav: UIButton!
    @IBOutlet weak var titre: UILabel!
    @IBOutlet weak var bannerView: GADBannerView!
    var interstitial: GADInterstitial!
    
    @IBOutlet weak var wbv: UIView!
    
    var error: Bool?
    var url = ""
    var name  = ""
    var id = ""
    var iduser : String?
    let defaults = UserDefaults.standard
    var book: Book?
    
    let hud = JGProgressHUD(style: .dark)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bannerView.delegate = self
        //realise ads id
        //bannerView.adUnitID = "ca-app-pub-8219247197168750/1371252929"
        iduser = defaults.string(forKey: "user_uid")
        
        //test code ads id
        bannerView.adUnitID = bannerid
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        titre.text = name
        hud.textLabel.text = "الرجاء الانتظار قليلاً جاري تحميل الكتاب"
        //hud.show(in: self.view)
        ToastMessage(message: "الرجاء الانتظار قليلاً جاري تحميل الكتاب")

        DispatchQueue.main.async {
            let url = NSURL(string: ResourceUrl + self.url)
            HttpDownloader.loadFileSync(url: url! as NSURL, completion:{(path:String, error:NSError!) in
                print("pdf downloaded to: \(path)")
                let url = URL(fileURLWithPath: path)
                self.hud.dismiss(afterDelay: 0.0)
                var   requset = URLRequest(url: url)
               // self.wbv.loadRequest(requset)
                
                let webview = WKWebView(frame: self.wbv.frame)
                self.wbv.addSubview(webview)
                webview.load(requset)
                
            })
            // }
        }
      

        if book != nil{
            if (book?.iSMyFavorite)! {
                let origImage = UIImage(named: "23911")
                let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
                fav.setImage(tintedImage, for: .normal)
                fav.tintColor = .gray
            }
        }
        
        
        interstitial = GADInterstitial(adUnitID: intersectid)
        interstitial.delegate = self
        let request = GADRequest()
        interstitial.load(request)
        
        var timer = Timer.scheduledTimer(timeInterval: 66, target: self, selector: #selector(self.ShowFullScreen), userInfo: nil, repeats: true)
    }
    
    @objc func ShowFullScreen(){
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
            print("Ad  ready")
        } else {
            print("Ad wasn't ready")
        }
    }
    
    @IBAction func Close(_ sender: Any) {
        // self.navigationController?.popViewController(animated: true)
        // self.dismiss(animated: true, completion: nil)
        if let close = self.navigationController?.popToRootViewController(animated: true) {
            
        }else{
             self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func Share(_ sender: Any) {
        let text = name
        let image = UIImage(named: "AppIcon")
        let myWebsite = NSURL(string: ResourceUrl + self.url)
        let shareAll = [text , image! , myWebsite] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func Favorite(_ sender: Any) {
        let parameters: Parameters = [
            "id_user": iduser as! String,
            "id_object": id,
            "Type_object": "book"
        ]
        print(parameters)
        Alamofire.request(Favorit, method: .post, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                if let results = response.result.value as? NSDictionary{
                    self.error = results["error"] as? Bool
                    if (self.error == true){
                        print("error")
                    }else{
                        if (results["message"]as! String == "favorit added")
                        {
                            self.showToast(message: "تم اضافة الكتاب الى قائمتك المفضلة")
                        }else{
                            self.showToast(message: "تم ازالة الكتاب من قائمتك المفضلة")
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
    
    @IBAction func Refresh(_ sender: Any) {
        hud.textLabel.text = "جاري تحميل ..."
        hud.show(in: self.view)
        self.hud.dismiss(afterDelay: 2.0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("adViewDidReceiveAd")
    }
    
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("adViewWillPresentScreen")
    }
    
    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("adViewWillDismissScreen")
    }
    
    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("adViewDidDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("adViewWillLeaveApplication")
    }
    
    
    /// Tells the delegate an ad request succeeded.
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        print("interstitialDidReceiveAd")
    }
    
    /// Tells the delegate an ad request failed.
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        print("interstitial:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that an interstitial will be presented.
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
        print("interstitialWillPresentScreen")
        
    }
    
    /// Tells the delegate the interstitial is to be animated off the screen.
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        print("interstitialWillDismissScreen")
    }
    
    /// Tells the delegate the interstitial had been animated off the screen.
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        print("interstitialDidDismissScreen")
        interstitial = GADInterstitial(adUnitID: intersectid)
        interstitial.delegate = self
        let request = GADRequest()
        interstitial.load(request)
        
    }
    
    /// Tells the delegate that a user click will open another app
    /// (such as the App Store), backgrounding the current app.
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
        print("interstitialWillLeaveApplication")
    }
    
    
    
    
    func ToastMessage(message : String){
        let snackbar = TTGSnackbar(message: message , duration: .short)
        snackbar.show()
        
    }
    
}
