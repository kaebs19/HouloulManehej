//
//  Notification.swift
//  Manehej
//
//  Created by pommestore on 24/07/2018.
//  Copyright © 2018 octadev. All rights reserved.
//

import Foundation

public class Notification {
    public var id : Int?
    public var response : String?
    public var id_question : String?
    public var id_user : String?
    public var created_at : String?
    public var updated_at : String?
    public var user : User?
    public var question : Question?
    public var show : Bool = false
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let notification_list = Notification.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Notification Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [Notification]
    {
        var models:[Notification] = []
        for item in array
        {
            models.append(Notification(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let notification = Notification(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Notification Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        id = dictionary["id"] as? Int
        response = dictionary["response"] as? String
        id_question = dictionary["id_question"] as? String
        id_user = dictionary["id_user"] as? String
        created_at = dictionary["created_at"] as? String
        updated_at = dictionary["updated_at"] as? String
        if (dictionary["user"] != nil) { user = User(dictionary: dictionary["user"] as! NSDictionary) }
        if (dictionary["question"] != nil) { question = Question(dictionary: dictionary["question"] as! NSDictionary) }
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.id, forKey: "id")
        dictionary.setValue(self.response, forKey: "response")
        dictionary.setValue(self.id_question, forKey: "id_question")
        dictionary.setValue(self.id_user, forKey: "id_user")
        dictionary.setValue(self.created_at, forKey: "created_at")
        dictionary.setValue(self.updated_at, forKey: "updated_at")
        dictionary.setValue(self.user?.dictionaryRepresentation(), forKey: "user")
        dictionary.setValue(self.question?.dictionaryRepresentation(), forKey: "question")
        
        return dictionary
    }
    
}

