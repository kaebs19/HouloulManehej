//
//  Question.swift
//  Manehej
//
//  Created by pommestore on 24/07/2018.
//  Copyright © 2018 octadev. All rights reserved.
//

import Foundation


public class Question {
    public var id : Int?
    public var class_name : String?
    public var matiere_name : String?
    public var description : String?
    public var id_user : String?
    public var created_at : String?
    public var updated_at : String?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let question_list = Question.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Question Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [Question]
    {
        var models:[Question] = []
        for item in array
        {
            models.append(Question(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let question = Question(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Question Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        id = dictionary["id"] as? Int
        class_name = dictionary["class_name"] as? String
        matiere_name = dictionary["matiere_name"] as? String
        description = dictionary["description"] as? String
        id_user = dictionary["id_user"] as? String
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
        dictionary.setValue(self.class_name, forKey: "class_name")
        dictionary.setValue(self.matiere_name, forKey: "matiere_name")
        dictionary.setValue(self.description, forKey: "description")
        dictionary.setValue(self.id_user, forKey: "id_user")
        dictionary.setValue(self.created_at, forKey: "created_at")
        dictionary.setValue(self.updated_at, forKey: "updated_at")
        
        return dictionary
    }
    
}
