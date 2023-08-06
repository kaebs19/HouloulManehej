

import Foundation

public class Level {
    public var id : Int?
    public var name : String?
    public var state : Int?
    public var created_at : String?
    public var updated_at : String?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let level_list = Level.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Level Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [Level]
    {
        var models:[Level] = []
        for item in array
        {
            models.append(Level(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let level = Level(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Level Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        id = dictionary["id"] as? Int
        name = dictionary["name"] as? String
        state = dictionary["state"] as? Int
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
        dictionary.setValue(self.name, forKey: "name")
        dictionary.setValue(self.state, forKey: "state")
        dictionary.setValue(self.created_at, forKey: "created_at")
        dictionary.setValue(self.updated_at, forKey: "updated_at")
        
        return dictionary
    }
    
}
