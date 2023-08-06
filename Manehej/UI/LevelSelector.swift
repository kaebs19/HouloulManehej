//
//  LevelSelector.swift
//  Manehej
//
//  Created by pommestore on 20/07/2018.
//  Copyright © 2018 octadev. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol CanReceive {
    func dataRecived(position : Int)
}

class LevelSelector: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    public var error : Bool?
    var listeLevel :Array<LevelMat>?
    var matiere : Array<Matiere>?
    @IBOutlet weak var Cancel: UIButton!
    @IBOutlet weak var Done: UIButton!
    var pickerDataSource = ["الرياض", "جدة", "مكة", "الطائف"]
    var pos : Int = 0
    @IBOutlet weak var pickerView: UIPickerView!
    
    var delegate : CanReceive?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.bounds.size.height = UIScreen.main.bounds.size.height * 0.6
        self.view.bounds.size.width = UIScreen.main.bounds.size.width * 0.8

        // Do any additional setup after loading the view.
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
    }
    @IBAction func Close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func Select_Ok(_ sender: Any) {
        delegate?.dataRecived(position : pos )
        self.dismiss(animated: true, completion: nil)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pos = row
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.listeLevel!.count;
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let lev =  listeLevel![row] as LevelMat
        return lev.name
    }
    
    
    
}
