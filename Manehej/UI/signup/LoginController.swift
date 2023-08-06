//
//  LoginController.swift
//  Manehej
//
//  Created by pommestore on 23/07/2018.
//  Copyright © 2018 octadev. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import UIView_Shake
import Firebase
// [END usermanagement_view_import]
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit
import AuthenticationServices

class LoginController: UIViewController , GIDSignInUIDelegate , ASAuthorizationControllerDelegate , ASAuthorizationControllerPresentationContextProviding{
    
    
    @objc(LoginController)
    
    // [END signin_controller]
    let kSectionToken = 3
    let kSectionProviders = 2
    let kSectionUser = 1
    let kSectionSignIn = 0
    
    enum AuthProvider {
        case authEmail
        case authAnonymous
        case authFacebook
        case authGoogle
        case authTwitter
        case authPhone
        case authCustom
        case authPasswordless
    }
    
    /*! @var kOKButtonText
     @brief The text of the "OK" button for the Sign In result dialogs.
     */
    let kOKButtonText = "OK"
    
    /*! @var kTokenRefreshedAlertTitle
     @brief The title of the "Token Refreshed" alert.
     */
    let kTokenRefreshedAlertTitle = "Token"
    
    /*! @var kTokenRefreshErrorAlertTitle
     @brief The title of the "Token Refresh error" alert.
     */
    let kTokenRefreshErrorAlertTitle = "Get Token Error"
    
    /** @var kSetDisplayNameTitle
     @brief The title of the "Set Display Name" error dialog.
     */
    let kSetDisplayNameTitle = "Set Display Name"
    
    /** @var kUnlinkTitle
     @brief The text of the "Unlink from Provider" error Dialog.
     */
    let kUnlinkTitle = "Unlink from Provider"
    
    /** @var kChangeEmailText
     @brief The title of the "Change Email" button.
     */
    
    var action: UIAlertAction?
    
    @IBOutlet weak var progress: UIActivityIndicatorView!
    @IBOutlet weak var log: ButtonCorner!
    @IBOutlet weak var new: ButtonCorner!
    var error : Bool = true
    
    @IBOutlet weak var condition: CheckBox!
    @IBOutlet weak var password: EditText!
    @IBOutlet weak var phone: EditText!
    var userId:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //     userId = OneSignal.getPermissionSubscriptionState().subscriptionStatus.userId
        self.condition.isChecked = true
        // Do any additional setup after loading the view.
        let defaults = UserDefaults.standard
        let iduser = defaults.integer(forKey: "user_uid")
        if(iduser  >  0){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "MainActivity")
            self.present(controller, animated: true, completion: nil)
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func GoogleLog(_ sender: Any) {
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
        
    }
    
    @IBAction func FacebookLog(_ sender: Any) {
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            
            guard let accessToken = FBSDKAccessToken.current() else {
                print("Failed to get access token")
                return
            }
            
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            // Perform login by calling Firebase APIs
            FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.addActionSheetForiPad(actionSheet: alertController)
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                    return
                }
                
                self.SocialAuth(user: (user)!)
                //self.SocialAuth(user : user!)
                // Present the main view
                
            })
            
        }
    }
    
    @available(iOS 13.0, *)
    @IBAction func LoginApple(_ sender: Any) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
        
    }
    
    func SocialAuth(user: FIRUser)  {
        let photo: String = user.photoURL!.absoluteString
        let parameters: Parameters = [
            "name": user.displayName as! String,
            "id_twitter":  user.uid,
            "type" : "facebook",
            "photo": photo
            
        ]
        print(parameters)
        Alamofire.request(loginTwitter  , method: .post , parameters: parameters  ).responseJSON {
            response in
            if response.result.isSuccess {
                if let results = response.result.value as? NSDictionary{
                    print(results)
                    if (results["user"] != nil) {
                        let  person = User (dictionary: results["user"]as Any as! NSDictionary)!
                        let defaults = UserDefaults.standard
                        defaults.set(person.id?.description, forKey: "user_uid")
                        defaults.set(person.first_name, forKey: "user_name")
                        defaults.set(person.photo, forKey: "user_photo")
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let controller = storyboard.instantiateViewController(withIdentifier: "MainController")
                        self.present(controller, animated: true, completion: nil)
                    }
                }
                else
                if response.result.isFailure {
                    print ("chiheb")
                }
                
            }
        }
    }
    func firebaseLogin(_ credential: FIRAuthCredential) {
        if let user = FIRAuth.auth()?.currentUser {
            // [START link_credential]
            user.link(with: credential , completion: { (authResult, error) in
                // [START_EXCLUDE]
                //self.hideSpinner {
                if let error = error {
                    print("Something went wrong with our FB user: ", error ?? "")
                    return
                }
                //  }
                // [END_EXCLUDE]
            })
            // [END link_credential]
        } else {
            // [START signin_credential]
            FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
                if error != nil {
                    print("Something went wrong with our FB user: ", error ?? "")
                    return
                }
                
                print("Successfully logged in with our user: ", user ?? "")
            })
        }
        
    }
    
    @IBAction func Login(_ sender: Any) {
        error = true
        if((phone.text?.count)! < 6){
            self.error = false
            self.phone.shake(10, withDelta: 5.0)
            
        }else
        if((password.text?.count)! < 6){
            self.error = false
            self.password.shake(10, withDelta: 5.0)
        }
        
        if self.error {
            let parameters: Parameters = [
                "email": phone.text as! String,
                "password": password.text as! String
            ]
            self.log.isHidden = true
            self.new.isHidden = true
            self.progress.alpha = 1
            Alamofire.request(login  , method: .post , parameters: parameters ).responseJSON {
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
                            self.log.isHidden = false
                            self.new.isHidden = false
                            self.progress.alpha = 0
                        }
                    }
                }
                else
                if response.result.isFailure {
                    self.log.isHidden = false
                    self.new.isHidden = false
                    self.progress.alpha = 0
                }
            }
        }
    }
    @IBAction func Ingore(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.set(nil, forKey: "user_uid")
        defaults.set("", forKey: "user_name")
        defaults.set("", forKey: "user_photo")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MainController")
        self.present(controller, animated: true, completion: nil)
        
    }
    
    
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
        
    }
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            // Create an account in your system.
            let userIdentifier = appleIDCredential.user
            let userFirstName = appleIDCredential.fullName?.givenName ?? ""
            let userLastName = appleIDCredential.fullName?.familyName ?? ""
            let userEmail = appleIDCredential.email ?? ""
            let photo = appleIDCredential.fullName?.description ?? ""
            print("userIdentifier" , appleIDCredential.user)
            
            guard let token = appleIDCredential.identityToken else { return  }
            // let idToken = appleIDCredential.identityToken
            
            if let tokeStr = String(data: token, encoding: .utf8){
                
                guard let code = appleIDCredential.authorizationCode else {
                    return
                }
                let codeStr = String(data: code, encoding: .utf8)
                let parameters: Parameters = [
                    "name": userFirstName + " " + userLastName,
                    "id_twitter":  appleIDCredential.user ,
                    "type" : "apple",
                    "last_name": "apple"

                ]
                print(parameters)
                Alamofire.request( loginTwitter , method: .post , parameters: parameters  ).responseJSON {
                    response in
                    print(response)
                    if response.result.isSuccess {
                        if let results = response.result.value as? NSDictionary{
                            print("result.isSuccess" , results)
                            if (results["user"] != nil) {
                                let  person = User (dictionary: results["user"]as Any as! NSDictionary)!
                                let defaults = UserDefaults.standard
                                defaults.set(person.id, forKey: "user_uid")
                                defaults.set(person.first_name, forKey: "user_name")
                                defaults.set(person.photo, forKey: "user_photo")
                                
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let controller = storyboard.instantiateViewController(withIdentifier: "MainController")
                                self.present(controller, animated: true, completion: nil)
                            }
                        }
                        else
                        if response.result.isFailure {
                            print ("chiheb")
                        }
                    }
                }
                
            }
            //Navigate to other view controller
        } else if let passwordCredential = authorization.credential as? ASPasswordCredential {
            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password
        }
    }
}
