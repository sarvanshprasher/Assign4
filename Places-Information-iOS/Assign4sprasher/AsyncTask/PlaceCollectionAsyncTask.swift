//
//  PlaceCollectionAsyncTask.swift
//  Assign4sprasher
//
//  Created by sarvansh prasher on 1/22/20.
//  Copyright © 2020 Sarvansh prasher. All rights reserved.
//

// Rights to use this code given to Arizona State University
// & Professor Timothy Lindquist (Tim.Lindquist@asu.edu) for course SER 423
// @author Sarvansh Prasher mailto:sprasher@asu.edu
// @version 20 January,2020
//
//
// References Timothy Lindquist Sources

import Foundation

public class PlaceCollectionAsyncTask {
    
    static var id:Int = 0
    
    var url:String
    
    init(urlString: String){
        self.url = urlString
    }
    
    // used by methods below to send a request asynchronously.
    // creates and posts a URLRequest that attaches a JSONRPC request as a Data object. The URL session
    // executes in the background and calls its completion handler when the result is available.
    func asyncHttpPostJSON(url: String,  data: Data,
                           completion: @escaping (String, String?) -> Void) {
        
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "POST"
        request.addValue("application/json",forHTTPHeaderField: "Content-Type")
        request.addValue("application/json",forHTTPHeaderField: "Accept")
        request.httpBody = data as Data
        //HTTPsendRequest(request: request, callback: completion)
        // task.resume() below, causes the shared session http request to be posted in the background
        // (independent of the UI Thread)
        // the use of the DispatchQueue.main.async causes the callback to occur on the main queue --
        // where the UI can be altered, and it occurs after the result of the post is received.
        let task:URLSessionDataTask = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) -> Void in
            if (error != nil) {
                completion("Error in URL Session", error!.localizedDescription)
            } else {
                DispatchQueue.main.async(execute: {completion(NSString(data: data!,
                                                                       encoding: String.Encoding.utf8.rawValue)! as String, nil)})
            }
        })
        task.resume()
    }

    func get(name: String, callback: @escaping (String, String?) -> Void) -> Bool{
        var ret:Bool = false
        PlaceCollectionAsyncTask.id = PlaceCollectionAsyncTask.id + 1
        do {
            let dict:[String:Any] = ["jsonrpc":"2.0", "method":"get", "params":[name], "id":PlaceCollectionAsyncTask.id]
            let reqData:Data = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions(rawValue: 0))
            self.asyncHttpPostJSON(url: self.url, data: reqData, completion: callback)
            ret = true
        } catch let error as NSError {
            print(error)
        }
        return ret
    }
    
    
    func getNames(callback: @escaping (String, String?) -> Void) -> Bool{
        var ret:Bool = false
        PlaceCollectionAsyncTask.id = PlaceCollectionAsyncTask.id + 1
        do {
            let dict:[String:Any] = ["jsonrpc":"2.0", "method":"getNames", "params":[ ], "id":PlaceCollectionAsyncTask.id]
            let reqData:Data = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions(rawValue: 0))
            self.asyncHttpPostJSON(url: self.url, data: reqData, completion: callback)
            ret = true
        } catch let error as NSError {
            print(error)
        }
        return ret
    }
    
    func add(place: PlaceDescription, callback: @escaping (String, String?) -> Void) -> Bool{
        var ret:Bool = false
        PlaceCollectionAsyncTask.id = PlaceCollectionAsyncTask.id + 1
        do {
            let dict:[String:Any] = ["jsonrpc":"2.0", "method":"add", "params":[place.toDict()], "id":PlaceCollectionAsyncTask.id]
            let reqData:Data = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions(rawValue: 0))
            self.asyncHttpPostJSON(url: self.url, data: reqData, completion: callback)
            ret = true
        } catch let error as NSError {
            print(error)
        }
        return ret
    }
    
    func remove(placeName: String, callback: @escaping (String, String?) -> Void) -> Bool{
        var ret:Bool = false
        PlaceCollectionAsyncTask.id = PlaceCollectionAsyncTask.id + 1
        do {
            let dict:[String:Any] = ["jsonrpc":"2.0", "method":"remove", "params":[placeName], "id":PlaceCollectionAsyncTask.id]
            let reqData:Data = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions(rawValue: 0))
            self.asyncHttpPostJSON(url: self.url, data: reqData, completion: callback)
            ret = true
        } catch let error as NSError {
            print(error)
        }
        return ret
    }
    
}
