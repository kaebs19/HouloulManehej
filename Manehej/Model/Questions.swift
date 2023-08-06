

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class Questions {
	public var id : Int?
	public var class_name : Class_name?
	public var matiere_name : Matiere?
	public var description : String?
	public var user : User?
	public var created_at : String?
	public var updated_at : String?
    public var response : Array<Response>?

    public class func modelsFromDictionaryArray(array:NSArray) -> [Questions]
    {
        var models:[Questions] = []
        for item in array
        {
            models.append(Questions(dictionary: item as! NSDictionary)!)
        }
        return models
    }


	required public init?(dictionary: NSDictionary) {

		id = dictionary["id"] as? Int
		if (dictionary["class_name"] != nil) {
            class_name = Class_name(dictionary: dictionary["class_name"] as! NSDictionary)
        }
        
        
		if (dictionary["matiere_name"] != nil) {
           // matiere_name = Matiere(dictionary: dictionary["matiere_name"] as! NSDictionary)
        }
		description = dictionary["description"] as? String
		if (dictionary["id_user"] != nil) { user = User(dictionary: dictionary["id_user"] as! NSDictionary) }
		created_at = dictionary["created_at"] as? String
		updated_at = dictionary["updated_at"] as? String
        if (dictionary["response"] != nil) { response = Response.modelsFromDictionaryArray(array: dictionary["response"] as! NSArray) }

	}

		

	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.id, forKey: "id")
		dictionary.setValue(self.class_name?.dictionaryRepresentation(), forKey: "class_name")
		dictionary.setValue(self.matiere_name?.dictionaryRepresentation(), forKey: "matiere_name")
		dictionary.setValue(self.description, forKey: "description")
		dictionary.setValue(self.user?.dictionaryRepresentation(), forKey: "id_user")
		dictionary.setValue(self.created_at, forKey: "created_at")
		dictionary.setValue(self.updated_at, forKey: "updated_at")

		return dictionary
	}

}
