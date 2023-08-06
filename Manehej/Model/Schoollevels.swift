
import Foundation
import SwiftyJSON
public class Schoollevels {
    public var id : Int?
    public var name : String?
    public var photo : String?
    public var id_level : String?
    public var state : Int?
    public var created_at : String?
    public var updated_at : String?
    public var level : Level?
    public var myFollow : Bool?
    public var nbbook : Int?
    
   
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [Schoollevels]
    {
        var models:[Schoollevels] = []
        for item in array
        {
            models.append(Schoollevels(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
   
    
    required public init?(dictionary: NSDictionary) {
        
        id = dictionary["id"] as? Int
        name = dictionary["name"] as? String
        photo = dictionary["photo"] as? String
        id_level = dictionary["id_level"] as? String
        state = dictionary["state"] as? Int
        created_at = dictionary["created_at"] as? String
        updated_at = dictionary["updated_at"] as? String
        if (JSON(rawValue: dictionary["level"]!) ?? [""] != JSON.null) {
            level = Level(dictionary: dictionary["level"] as! NSDictionary)
        }
        myFollow = dictionary["MyFollow"] as? Bool
        nbbook = dictionary["nbbook"] as? Int
    }
    
    
  
    
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.id, forKey: "id")
        dictionary.setValue(self.name, forKey: "name")
        dictionary.setValue(self.photo, forKey: "photo")
        dictionary.setValue(self.id_level, forKey: "id_level")
        dictionary.setValue(self.state, forKey: "state")
        dictionary.setValue(self.created_at, forKey: "created_at")
        dictionary.setValue(self.updated_at, forKey: "updated_at")
        dictionary.setValue(self.level?.dictionaryRepresentation(), forKey: "level")
        dictionary.setValue(self.myFollow, forKey: "MyFollow")
        dictionary.setValue(self.nbbook, forKey: "nbbook")
        
        return dictionary
    }
    
}
