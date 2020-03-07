//
//  PlaceLibrary.swift
//  Assign4sprasher
//
//  Created by sarvansh prasher on 3/7/20.
//  Copyright © 2020 Sarvansh prasher. All rights reserved.
//

import Foundation

public class PlaceLibrary{
    
    var placesList:[String:PlaceDescription] = [String:PlaceDescription]()
    var names:[String] = [String]()
    
  
    public func toJsonString() -> String {
        var jsonStr = "";
        let dict:[String : Any] = ["name": names, "category": Category.self] as [String : Any]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
            jsonStr = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        } catch let error as NSError {
            print("unable to convert dictionary to a Json Object with error: \(error)")
        }
        return jsonStr
    }
    
    
}
