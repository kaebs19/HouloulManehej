//
//  Chat_Controller.swift
//  Manehej
//
//  Created by pommestore on 27/12/2018.
//  Copyright © 2018 octadev. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SocketIO
import GoogleMobileAds

class Chat_Controller: UIViewController ,UITableViewDataSource  , UITableViewDelegate, UITextViewDelegate ,GADInterstitialDelegate
, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.messages == nil {
            return 0
        }else{
            return (self.messages?.count)!
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message  = self.messages![indexPath.row]
        if(message.type == "text"){
            if message.id_user == Int(iduser!){
                let cell  = tableView.dequeueReusableCell(withIdentifier: "TextCell")as! TextCell
                cell.initialiser(message : message)
                return cell
            }else{
                let cell  = tableView.dequeueReusableCell(withIdentifier: "TextRecieveCell")as! TextRecieveCell
                cell.initialiser(message : message)
                return cell
            }
        }else{
            if message.id_user == Int(iduser!){
                let cell  = tableView.dequeueReusableCell(withIdentifier: "PhotoCell")as! PhotoCell
                cell.initialiser(message : message)
                return cell
                
            }else{
                let cell  = tableView.dequeueReusableCell(withIdentifier: "PhotoRecieveCell")as! PhotoRecieveCell
                cell.initialiser(message : message)
                return cell
            }
        }
    }
    
    var bannerView: GADBannerView!
    var interstitial: GADInterstitial!
    var imagePicker: UIImagePickerController!
    var files  : Array<UIImage> = []

    let manager = SocketManager(socketURL: URL(string: "http://173.249.52.14:3434")!, config: [.log(true), .compress])
    // public var messages : Array<Messages>?
    
    var unsubscribe_random = "unsubscribe"
    var subscribe_random = "subscribe"
    var message_random = "message"
    var send_random = "send"
    
    var iduser :String?
    var user_name :String?
    var photo_user : String = ""
    let defaults = UserDefaults.standard
    public var messages : Array<Message>?
    
    var name :String?
    var chatId = ""
    
    
    @IBOutlet weak var message: UITextView!
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        iduser = defaults.string(forKey: "user_uid")
        name = defaults.string(forKey: "user_name")
        photo_user = defaults.string(forKey: "user_photo")!
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        print("error ChatController")
        // Do any additional setup after loading the view.
        
        ConnectSocket()
        //initialiser Tableview
        self.tableview.delegate = self
        self.tableview.dataSource = self
        let nibName = UINib(nibName: "TextCell", bundle:nil)
        self.tableview.register(nibName, forCellReuseIdentifier: "TextCell")
        
        let nibName1 = UINib(nibName: "TextRecieveCell", bundle:nil)
        self.tableview.register(nibName1, forCellReuseIdentifier: "TextRecieveCell")
        
        let nibName2 = UINib(nibName: "PhotoRecieveCell", bundle:nil)
        self.tableview.register(nibName2, forCellReuseIdentifier: "PhotoRecieveCell")
        
        let nibName3 = UINib(nibName: "PhotoCell", bundle:nil)
        self.tableview.register(nibName3, forCellReuseIdentifier: "PhotoCell")
        
        // BAnner Ads
        bannerView = GADBannerView(frame: CGRect(x:0, y: 65, width : CGSizeFromGADAdSize(kGADAdSizeSmartBannerPortrait).width, height: CGSizeFromGADAdSize(kGADAdSizeSmartBannerPortrait).height))
        
        //realise ads id
        //bannerView.adUnitID = "ca-app-pub-8219247197168750/1371252929"
        //test code ads id
        view.addSubview(bannerView)
        bannerView.adUnitID = bannerid
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        interstitial = GADInterstitial(adUnitID: intersectid)
        interstitial.delegate = self
        let request = GADRequest()
        interstitial.load(request)
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            if self.interstitial.isReady {
                self.interstitial.present(fromRootViewController: self)
            } else {
                print("Ad wasn't ready")
            }
            
        }
        message.delegate = self
        self.message.textColor = UIColor.lightGray
        ListeMess()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if self.message.textColor == UIColor.lightGray {
            self.message.text = ""
            self.message.textColor = UIColor.black
        }
    }
    
    @IBAction func Close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func SendMessage(_ sender: Any) {
        if (self.message.text != "" && self.message.textColor != UIColor.lightGray)   {
            let newStr = self.message.text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            let jsonObject3: NSMutableDictionary = NSMutableDictionary()
            jsonObject3.setValue(self.chatId, forKey: "room")
            jsonObject3.setValue(newStr, forKey: "content")
            jsonObject3.setValue("text", forKey: "type")
            manager.defaultSocket.emit(send_random, jsonObject3)
            self.message.endEditing(true)
            self.message.text = " ارسل رسالة "
            self.message.textAlignment = .right
            self.message.textColor = UIColor.lightGray
            
        }else{
            
        }
    }
    
    @IBAction func PhotoSelect(_ sender: Any) {
        self.files.removeAll()
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // Create the actions
        let gallery = UIAlertAction(title: "معرض الصور", style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.selectImageFrom()

        }
        let camera  = UIAlertAction(title: "كاميرا", style: UIAlertAction.Style.default) {
            UIAlertAction in
             self.SelectFromCamera()
        }
        
        let cancelAction = UIAlertAction(title: "إلغاء", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
        }
        
        // Add the actions
        alertController.addAction(gallery)
        alertController.addAction(camera)
        alertController.addAction(cancelAction)
        addActionSheetForiPad(actionSheet: alertController)

        // Present the controller
        self.present(alertController, animated: true, completion: nil)
        
    }
    func selectImageFrom(){
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func SelectFromCamera(){
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let selectedImage = info[UIImagePickerControllerOriginalImage]as! UIImage
        UploadFile(selected : selectedImage)
        dismiss(animated: true, completion: nil)
    }

    
    
    func UploadFile(selected : UIImage){
        Alamofire.upload(multipartFormData:{(multipartFormData) in
            
            multipartFormData.append(UIImageJPEGRepresentation(selected, 0.1)!, withName: "image", fileName: "file.jpeg", mimeType: "image/jpeg")

            
            
        }, to: UploadPhoto , headers: nil )
        { (result) in
            switch result {
            case .success(let upload,_,_ ):
                upload.uploadProgress(closure: { (progress) in
                    print(progress)
                })
                upload.responseJSON
                    { response in
                        if let results = response.result.value as? NSDictionary{
                            if ((results["UploadPhoto"]) != nil) {
                                let newStr = self.message.text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
                                let jsonObject3: NSMutableDictionary = NSMutableDictionary()
                                jsonObject3.setValue(self.chatId, forKey: "room")
                                jsonObject3.setValue(results["UploadPhoto"], forKey: "content")
                                jsonObject3.setValue("image", forKey: "type")
                                self.manager.defaultSocket.emit(self.send_random, jsonObject3)
                                self.files.removeAll()
                            }
                        }
                }
            case .failure( _):
                do {
                    print("fail")
                    break
                }
            }
        }
        
    }
}
extension Chat_Controller {
    
    
    func ConnectSocket() {
        
        
        let socket = manager.defaultSocket
        
        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
            
            let jsonObject: NSMutableDictionary = NSMutableDictionary()
            jsonObject.setValue(self.iduser, forKey: "id_user")
            self.manager.defaultSocket.emit("login", jsonObject)
            
            let jsonObject2: NSMutableDictionary = NSMutableDictionary()
            jsonObject2.setValue(self.chatId, forKey: "room")
            self.manager.defaultSocket.emit(self.subscribe_random, jsonObject2)
            
        }
        socket.on(clientEvent: .error) {data, ack in
            print("socket error")
        }
        socket.on(clientEvent: .disconnect) {data, ack in
            print("socket disconnected")
        }
        
        socket.on(subscribe_random) {data, ack in
            print("socket subscribe")
        }
        
        socket.on(unsubscribe_random) {data, ack in
            print("socket unsubscribe")
        }
        
        socket.connect()
        
        AddMessage()
    }
    
    
    func AddMessage(){
        manager.defaultSocket.on(message_random) {data, ack in
            let cur = data[0] as? NSDictionary
            
            let mes = Message(dictionary: cur!["message"] as! NSDictionary)
            mes!.user = User(dictionary: cur!["user"] as! NSDictionary)
            
            self.messages?.append(mes!)
            self.tableview.reloadData()
            self.tableview.scrollToRow(at: IndexPath(item:self.messages!.count-1, section: 0), at: .bottom, animated: false)
            
        }
        
    }
    
    func ListeMess(){
        let params : Parameters = [
            "id_room": chatId as! String
        ]
        print(params)
        Alamofire.request(ListChatMatieres, method: .post   , parameters: params).responseJSON {
            response in
            if response.result.isSuccess {
                if let results = response.result.value as? NSDictionary{
                    print(results)
                    if (results["Chat"] != nil ) {
                        let chat  = Chat(dictionary:  results["Chat"] as! NSDictionary) as! Chat
                        self.messages = chat.message
                        DispatchQueue.main.async {
                            self.tableview.reloadData()
                            if self.messages!.count > 0 {
                                self.tableview.scrollToRow(at: IndexPath(item:self.messages!.count-1, section: 0), at: .bottom, animated: true)
                            }
                        }
                    }
                }
            }
            if response.result.isFailure {
                print("error")
            }
        }
        
    }
}
extension UIViewController {
    public func addActionSheetForiPad(actionSheet: UIAlertController) {
        if let popoverPresentationController = actionSheet.popoverPresentationController {
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverPresentationController.permittedArrowDirections = []
        }
    }
}
