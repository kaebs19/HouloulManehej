
import Foundation

/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class User {
    public var id : Int?
    public var first_name : String?
    public var last_name : String?
    public var email : String?
    public var password : String?
    public var about_user : String?
    public var clas : String?
    public var photo : String?
    public var score : String?
    public var remember_token : String?
    public var created_at : String?
    public var updated_at : String?
    public var blocked : Int?
    

    public class func modelsFromDictionaryArray(array:NSArray) -> [User]
    {
        var models:[User] = []
        for item in array
        {
            models.append(User(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    

    required public init?(dictionary: NSDictionary) {
        
        id = dictionary["id"] as? Int
        first_name = dictionary["first_name"] as? String
        last_name = dictionary["last_name"] as? String
        email = dictionary["email"] as? String
        password = dictionary["password"] as? String
        about_user = dictionary["about_user"] as? String
        clas = dictionary["class"] as? String
        photo = dictionary["photo"] as? String
        score = dictionary["score"] as? String
        remember_token = dictionary["remember_token"] as? String
        created_at = dictionary["created_at"] as? String
        updated_at = dictionary["updated_at"] as? String
        blocked = dictionary["blocked"] as? Int
        
    }
    
    
  
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.id, forKey: "id")
        dictionary.setValue(self.first_name, forKey: "first_name")
        dictionary.setValue(self.last_name, forKey: "last_name")
        dictionary.setValue(self.email, forKey: "email")
        dictionary.setValue(self.password, forKey: "password")
        dictionary.setValue(self.about_user, forKey: "about_user")
        dictionary.setValue(self.clas, forKey: "class")
        dictionary.setValue(self.photo, forKey: "photo")
        dictionary.setValue(self.score, forKey: "score")
        dictionary.setValue(self.remember_token, forKey: "remember_token")
        dictionary.setValue(self.created_at, forKey: "created_at")
        dictionary.setValue(self.updated_at, forKey: "updated_at")
        dictionary.setValue(self.blocked, forKey: "blocked")
        
        return dictionary
    }
    
}
