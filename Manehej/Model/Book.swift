
import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class Book {
	public var id : Int?
	public var title : String?
	public var description : String?
	public var url : String?
	public var id_matiere : String?
	public var id_class : String?
	public var photo : String?
	public var semester : String?
	public var created_at : String?
	public var updated_at : String?
	public var blocked : Int?
	public var nclass : String?
	public var matiere : String?
	public var drill : Array<Drill>?
    public var iSMyFavorite : Bool = true

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let book_list = Book.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Book Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Book]
    {
        var models:[Book] = []
        for item in array
        {
            models.append(Book(dictionary: item as! NSDictionary)!)
        }
        return models
    }


	required public init?(dictionary: NSDictionary) {

		id = dictionary["id"] as? Int
		title = dictionary["title"] as? String
		description = dictionary["description"] as? String
		url = dictionary["Url"] as? String
		id_matiere = dictionary["id_matiere"] as? String
		id_class = dictionary["id_class"] as? String
		photo = dictionary["photo"] as? String
		semester = dictionary["semester"] as? String
		created_at = dictionary["created_at"] as? String
		updated_at = dictionary["updated_at"] as? String
		blocked = dictionary["blocked"] as? Int
		nclass = dictionary["nclass"] as? String
		matiere = dictionary["matiere"] as? String
        if (dictionary["drill"] != nil) { drill = Drill.modelsFromDictionaryArray(array: dictionary["drill"] as! NSArray) }
        if (dictionary["iSMyFavorite"] != nil) {
            iSMyFavorite = (dictionary["iSMyFavorite"] as? Bool)!
        }
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.id, forKey: "id")
		dictionary.setValue(self.title, forKey: "title")
		dictionary.setValue(self.description, forKey: "description")
		dictionary.setValue(self.url, forKey: "Url")
		dictionary.setValue(self.id_matiere, forKey: "id_matiere")
		dictionary.setValue(self.id_class, forKey: "id_class")
		dictionary.setValue(self.photo, forKey: "photo")
		dictionary.setValue(self.semester, forKey: "semester")
		dictionary.setValue(self.created_at, forKey: "created_at")
		dictionary.setValue(self.updated_at, forKey: "updated_at")
		dictionary.setValue(self.blocked, forKey: "blocked")
		dictionary.setValue(self.nclass, forKey: "nclass")
		dictionary.setValue(self.matiere, forKey: "matiere")

		return dictionary
	}

}
