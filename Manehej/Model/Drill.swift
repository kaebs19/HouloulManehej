
import Foundation

/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class Drill {
    public var id : Int?
    public var title : String?
    public var description : String?
    public var id_book : String?
    public var photo : String?
    public var url : String?
    public var created_at : String?
    public var updated_at : String?
    public var _order : Int?
    
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [Drill]
    {
        var models:[Drill] = []
        for item in array
        {
            models.append(Drill(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    
    required public init?(dictionary: NSDictionary) {
        
        id = dictionary["id"] as? Int
        title = dictionary["title"] as? String
        description = dictionary["description"] as? String
        id_book = dictionary["id_book"] as? String
        photo = dictionary["photo"] as? String
        url = dictionary["url"] as? String
        created_at = dictionary["created_at"] as? String
        updated_at = dictionary["updated_at"] as? String
        _order = dictionary["_order"] as? Int
    }
    
    
    
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.id, forKey: "id")
        dictionary.setValue(self.title, forKey: "title")
        dictionary.setValue(self.description, forKey: "description")
        dictionary.setValue(self.id_book, forKey: "id_book")
        dictionary.setValue(self.photo, forKey: "photo")
        dictionary.setValue(self.url, forKey: "url")
        dictionary.setValue(self.created_at, forKey: "created_at")
        dictionary.setValue(self.updated_at, forKey: "updated_at")
        dictionary.setValue(self._order, forKey: "_order")
        
        return dictionary
    }
    
}
