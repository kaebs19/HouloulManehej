//
//  Matiere.swift
//  Manehej
//
//  Created by pommestore on 20/07/2018.
//  Copyright © 2018 octadev. All rights reserved.
//

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class Matiere {
    public var id : Int?
    public var id_schoollevels : String?
    public var state : Int?
    public var name : String?
    public var photo : String?
    public var semester : String?
    public var created_at : String?
    public var updated_at : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let matiere_name_list = Matiere_name.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Matiere_name Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Matiere]
    {
        var models:[Matiere] = []
        for item in array
        {
            models.append(Matiere(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let matiere_name = Matiere_name(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Matiere_name Instance.
*/
    required public init?(dictionary: NSDictionary) {

        id = dictionary["id"] as? Int
        id_schoollevels = dictionary["id_schoollevels"] as? String
        state = dictionary["state"] as? Int
        name = dictionary["name"] as? String
        photo = dictionary["photo"] as? String
        semester = dictionary["semester"] as? String
        created_at = dictionary["created_at"] as? String
        updated_at = dictionary["updated_at"] as? String
    }

        
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
    public func dictionaryRepresentation() -> NSDictionary {

        let dictionary = NSMutableDictionary()

        dictionary.setValue(self.id, forKey: "id")
        dictionary.setValue(self.id_schoollevels, forKey: "id_schoollevels")
        dictionary.setValue(self.state, forKey: "state")
        dictionary.setValue(self.name, forKey: "name")
        dictionary.setValue(self.photo, forKey: "photo")
        dictionary.setValue(self.semester, forKey: "semester")
        dictionary.setValue(self.created_at, forKey: "created_at")
        dictionary.setValue(self.updated_at, forKey: "updated_at")

        return dictionary
    }

}
