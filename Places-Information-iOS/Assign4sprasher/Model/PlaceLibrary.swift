//
//  PlaceLibrary.swift
//  Assign4sprasher
//
//  Created by sarvansh prasher on 3/7/20.
//  Copyright © 2020 Sarvansh prasher. All rights reserved.
//  Rights to use this code given to Arizona State University
//  & Professor Timothy Lindquist (Tim.Lindquist@asu.edu) for course SER 423
//  @author Sarvansh Prasher mailto:sprasher@asu.edu
//  @version 7 March,2020
//

import Foundation

public class PlaceLibrary{
    
    var placesList:[String:PlaceDescription] = [String:PlaceDescription]()
    var names:[String] = [String]()
    
    func getData() -> [String:PlaceDescription]{
        
        if let path = Bundle.main.path(forResource: "places", ofType: "json"){
            do {
                let jsonStr:String = try String(contentsOfFile:path)
                let data:Data = jsonStr.data(using: String.Encoding.utf8)!
                let dict:[String:Any] = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String:Any]
                for places:String in dict.keys {
                    let place:PlaceDescription = PlaceDescription(dict: dict[places] as! [String:Any])
                    self.placesList[places] = place
                }
            } catch {
                print("List not loading")
            }
        }
        
        return placesList
    }
    
    
    func toJsonString() -> String {
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
