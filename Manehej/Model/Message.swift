/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class Message {
	public var id : Int?
	public var msg : String?
	public var type : String?
	public var status : Int?
	public var id_user : Int?
	public var id_room : Int?
	public var created_at : String?
	public var updated_at : String?
	public var user : User?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let message_list = Message.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Message Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Message]
    {
        var models:[Message] = []
        for item in array
        {
            models.append(Message(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let message = Message(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Message Instance.
*/
	required public init?(dictionary: NSDictionary) {

		id = dictionary["id"] as? Int
		msg = dictionary["msg"] as? String
		type = dictionary["type"] as? String
		status = dictionary["status"] as? Int
		id_user = dictionary["id_user"] as? Int
		id_room = dictionary["id_room"] as? Int
		created_at = dictionary["created_at"] as? String
		updated_at = dictionary["updated_at"] as? String
		if (dictionary["user"] != nil ) { user = User(dictionary: dictionary["user"] as! NSDictionary) }
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.id, forKey: "id")
		dictionary.setValue(self.msg, forKey: "msg")
		dictionary.setValue(self.type, forKey: "type")
		dictionary.setValue(self.status, forKey: "status")
		dictionary.setValue(self.id_user, forKey: "id_user")
		dictionary.setValue(self.id_room, forKey: "id_room")
		dictionary.setValue(self.created_at, forKey: "created_at")
		dictionary.setValue(self.updated_at, forKey: "updated_at")
		dictionary.setValue(self.user?.dictionaryRepresentation(), forKey: "user")

		return dictionary
	}

}
