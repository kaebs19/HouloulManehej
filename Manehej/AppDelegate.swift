 //
 //  AppDelegate.swift
 //  Manehej
 //
 //  Created by pommestore on 07/07/2018.
 //  Copyright © 2018 octadev. All rights reserved.
 //
 
 import UIKit
 import IQKeyboardManager
 import Firebase
 import FirebaseCore
 import Alamofire
 import SwiftyJSON
 import GoogleMobileAds
 import OneSignal
 // [START google_import]
 import GoogleSignIn
 // [END google_import]
 import FBSDKCoreKit
 // import OneSignal
 
 
 
 @UIApplicationMain
 class AppDelegate: UIResponder, UIApplicationDelegate  , GIDSignInDelegate{
    let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared().isEnabled = true
        createDirectory()
        
        // Sample AdMob app ID: ca-app-pub-3940256099942544~1458002511
        GADMobileAds.configure(withApplicationID: "ca-app-pub-8219247197168750~6844229008")
        
        FIRApp.configure()
        
        // [START setup_gidsignin]
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        // [END setup_gidsignin]
        FBSDKApplicationDelegate.sharedInstance().application(application,
                                                              didFinishLaunchingWithOptions:launchOptions)
        /*  for familyName:String in UIFont.familyNames {
         print("Family Name: \(familyName)")
         for fontName:String in UIFont.fontNames(forFamilyName: familyName) {
         print("--Font Name: \(fontName)")
         }
         }*/
        
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Cairo-Regular", size: 20),NSAttributedStringKey.foregroundColor: UIColor.black]
        
        UIFont.overrideInitialize()
        
        UITabBar.appearance().tintColor = UIColor(red: 255/255.0, green: 87/255.0, blue: 34/255.0, alpha: 1.0)
        // UITabBar.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState: UIControlState.Normal)
        UITabBarItem.appearance().setTitleTextAttributes([kCTForegroundColorAttributeName as NSAttributedStringKey: UIColor.red], for: .selected) //This is the text color
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "Cairo-Regular", size: 10)!], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "Cairo-Regular", size: 10)!], for: .selected)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Cairo-Regular", size: 20),NSAttributedStringKey.foregroundColor: UIColor.black]
        
        if #available(iOS 11.0, *) {
            UINavigationBar.appearance().largeTitleTextAttributes =
                [NSAttributedStringKey.foregroundColor: UIColor.black,
                 NSAttributedStringKey.font: UIFont(name: "Cairo-Regular", size: 27) ??
                    UIFont.systemFont(ofSize: 27)]
        } else {
            
            
        }
        
        
        // Replace 'YOUR_APP_ID' with your OneSignal App ID.
        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId: "c4cf5f86-154b-44c4-9e34-de0b2b1b8367",
                                        handleNotificationAction: nil,
                                        settings: onesignalInitSettings)
        
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
        
        // Recommend moving the below line to prompt for push after informing the user about
        //   how your app will use them.
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
        })
        
           if !UserDefaults.standard.bool(forKey: "isFirstLaunch") {
               UserDefaults.standard.set(true, forKey: "isFirstLaunch")
           }
  
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        // [END old_delegate]
        
        if GIDSignIn.sharedInstance().handle(url,
                                             sourceApplication: sourceApplication,
                                             annotation: annotation) {
            return true
        }
        return FBSDKApplicationDelegate.sharedInstance().application(application,
                                                                     open: url,
                                                                     // [START old_options]
                                                                     sourceApplication: sourceApplication,
                                                                     annotation: annotation)
    }
    // [END old_options]
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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
    
    func deleteDirectory(){
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("ManehejDirectory")
        if fileManager.fileExists(atPath: paths){
            try! fileManager.removeItem(atPath: paths)
        }else{
            print("Something wronge.")
        }
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error) != nil {
            print("An error occured during Google Authentication")
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = FIRGoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                          accessToken: authentication.accessToken)
        FIRAuth.auth()?.signIn(with: credential) { (user, error) in
            if (error) != nil {
                print("Google Authentification Fail")
            } else {
                print("Google Authentification Success")
                self.SocialAuth(user: (user)!)
                
                
            }
        }
    }
    func SocialAuth(user: FIRUser)  {
        //        userId = OneSignal.getPermissionSubscriptionState().subscriptionStatus.userId
        let photo: String = user.photoURL!.absoluteString
        
        let parameters: Parameters = [
            "name": user.displayName as! String,
            "id_twitter":  user.uid ,
            "type" : "google",
            "photo": photo
        ]
        print(parameters)
        Alamofire.request( loginTwitter , method: .post , parameters: parameters  ).responseJSON {
            response in
            if response.result.isSuccess {
                if let results = response.result.value as? NSDictionary{
                    print(results)
                    if (results["user"] != nil) {
                        let  person = User (dictionary: results["user"]as Any as! NSDictionary)!
                        let defaults = UserDefaults.standard
                        defaults.set(person.id, forKey: "user_uid")
                        defaults.set(person.first_name, forKey: "user_name")
                        defaults.set(person.photo, forKey: "user_photo")
                        
                        let mainStoryBoard: UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
                        let protectedPage = mainStoryBoard.instantiateViewController(withIdentifier: "MainController")
                        let appDelegate = UIApplication.shared.delegate
                        appDelegate?.window??.rootViewController = protectedPage
                    }
                }
                else
                if response.result.isFailure {
                    print ("chiheb")
                }
            }
        }
    }
 }
