//
//  NewQuestionController.swift
//  Manehej
//
//  Created by pommestore on 08/07/2018.
//  Copyright © 2018 octadev. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import FittedSheets
import UIView_Shake
import LSDialogViewController

class NewQuestionController: UIViewController ,UITextFieldDelegate, CanReceive ,CanReceive1{
   
    
    var verif :Bool = true
    var listeLevel :Array<LevelMat>?
    var listematiere :Array<Matiere>?
    @IBOutlet weak var caracter: UILabel!
    @IBOutlet weak var level: UITextField!
    @IBOutlet weak var matiere: UITextField!
    @IBOutlet weak var question: UITextField!
    public var error : Bool?
    let defaults = UserDefaults.standard
    var iduser : String?
    var id_clas :Int?
    var id_mat :Int?

    
    
    
    func dataRecived(position: Int) {
        let lev =  listeLevel![position] as LevelMat
        level.text = lev.name
        matiere.text = ""
        listematiere = lev.matiere
        id_clas = lev.id
        }
    func dataRecived1(position: Int) {
        let lev =  listematiere![position] as Matiere
        matiere.text = lev.name
        id_mat = lev.id
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        question.delegate = self
        iduser = defaults.string(forKey: "user_uid")
        ALLLevel()
        let tap = UITapGestureRecognizer(target: self,action: #selector(Level(tapGestureRecognizer:)))
        level.isUserInteractionEnabled = true
        level.addGestureRecognizer(tap)
        
        let tap1 = UITapGestureRecognizer(target: self,action: #selector(Matier(tapGestureRecognizer:)))
        matiere.isUserInteractionEnabled = true
        matiere.addGestureRecognizer(tap1)
        
        // Do any additional setup after loading the view.
    }
    @objc func Level(tapGestureRecognizer: UITapGestureRecognizer){
        self.showDialog(.fadeInOut)
        
    }
    @objc func Matier(tapGestureRecognizer: UITapGestureRecognizer){
        self.showDialog1(.fadeInOut)
        
    }
    
    fileprivate func showDialog(_ animationPattern: LSAnimationPattern) {
        let vc: LevelSelector = self.storyboard?.instantiateViewController(withIdentifier: "LevelSelector") as! LevelSelector
        vc.listeLevel = self.listeLevel
        vc.delegate = self
        //AJBottomSheetViewController.show(viewController: vc, height: 250, parent: self)
        let sheet = SheetViewController(controller: vc, sizes: [.fixed(250)])
        sheet.didDismiss = { _ in
            // This is called after the sheet is dismissed
        }
        self.present(sheet, animated: false, completion: nil)

    }
    
    fileprivate func showDialog1(_ animationPattern: LSAnimationPattern) {
        let vc: MatiereSelector = self.storyboard?.instantiateViewController(withIdentifier: "MatiereSelector") as! MatiereSelector
        vc.matiere = self.listematiere
        vc.delegate = self
        //AJBottomSheetViewController.show(viewController: vc, height: 250, parent: self)
        let sheet = SheetViewController(controller: vc, sizes: [.fixed(250)])
        sheet.didDismiss = { _ in
            // This is called after the sheet is dismissed
        }
        self.present(sheet, animated: false, completion: nil)

    }
    
    func dismissDialog() {
        self.dismissDialogViewController(LSAnimationPattern.fadeInOut)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func AddQuestion(_ sender: Any) {
        verif = true
        if level.text == "" {
            level.shake(10, withDelta: 5.0)
            verif = false
        }else
        if matiere.text == "" {
            matiere.shake(10, withDelta: 5.0)
            verif = false
        }else
        if verif {
            AddQ()
        }
        
    }
    
    func AddQ(){
        print("\(self.iduser as! String)")
        let parameters: Parameters = [
            "id_user":  "\(self.iduser as! String)" ,
            "class_id": id_clas,
            "matiere_id": id_mat,
            "question": self.question.text as! String,
            ]
        
        Alamofire.request(AdQuestion, method: .post, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                if let results = response.result.value as? NSDictionary{
                    self.error = results["error"] as? Bool
                    if (self.error == true){
                        print("error")
                    }else{
                        self.dismiss(animated: true, completion: nil)
                    }
                    
                }
            }
            else
                if response.result.isFailure {
                    print ("chiheb")
            }
        }
        
    }
    
    
    func ALLLevel() {
        
        Alamofire.request(ALevel , method: .get ).responseJSON {
            response in
            if response.result.isSuccess {
                
                
                if let results = response.result.value as? NSDictionary{
                    self.error = results["error"] as? Bool
                    if (self.error == true){
                        print("error")
                    }else{
                        if (results["LevelMat"] != nil) {
                            self.listeLevel = LevelMat.modelsFromDictionaryArray(array: results["LevelMat"] as! NSArray)
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
