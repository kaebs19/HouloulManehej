//
//  LevelMat.swift
//  Manehej
//
//  Created by pommestore on 20/07/2018.
//  Copyright © 2018 octadev. All rights reserved.
//

import Foundation

public class LevelMat {
    public var id : Int?
    public var name : String?
    public var photo : String?
    public var id_level : String?
    public var state : Int?
    public var created_at : String?
    public var updated_at : String?
    public var matiere : Array<Matiere>?

    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let levelMat_list = LevelMat.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of LevelMat Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [LevelMat]
    {
        var models:[LevelMat] = []
        for item in array
        {
            models.append(LevelMat(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let levelMat = LevelMat(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: LevelMat Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        id = dictionary["id"] as? Int
        name = dictionary["name"] as? String
        photo = dictionary["photo"] as? String
        id_level = dictionary["id_level"] as? String
        state = dictionary["state"] as? Int
        created_at = dictionary["created_at"] as? String
        updated_at = dictionary["updated_at"] as? String
        if (dictionary["matiere"] != nil) { matiere = Matiere.modelsFromDictionaryArray(array: dictionary["matiere"] as! NSArray) }

    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.id, forKey: "id")
        dictionary.setValue(self.name, forKey: "name")
        dictionary.setValue(self.photo, forKey: "photo")
        dictionary.setValue(self.id_level, forKey: "id_level")
        dictionary.setValue(self.state, forKey: "state")
        dictionary.setValue(self.created_at, forKey: "created_at")
        dictionary.setValue(self.updated_at, forKey: "updated_at")
        dictionary.setValue(self.matiere, forKey: "matiere")

        return dictionary
    }
    
}
