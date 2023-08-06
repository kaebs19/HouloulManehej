/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class Chat {
	public var id : Int?
	public var name : String?
	public var photo : String?
	public var id_level : String?
	public var state : Int?
	public var created_at : String?
	public var updated_at : String?
	public var message : Array<Message>?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let chat_list = Chat.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Chat Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Chat]
    {
        var models:[Chat] = []
        for item in array
        {
            models.append(Chat(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let chat = Chat(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Chat Instance.
*/
	required public init?(dictionary: NSDictionary) {

		id = dictionary["id"] as? Int
		name = dictionary["name"] as? String
		photo = dictionary["photo"] as? String
		id_level = dictionary["id_level"] as? String
		state = dictionary["state"] as? Int
		created_at = dictionary["created_at"] as? String
		updated_at = dictionary["updated_at"] as? String
        if (dictionary["message"] != nil) { message = Message.modelsFromDictionaryArray(array: dictionary["message"] as! NSArray) }
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

		return dictionary
	}

}
