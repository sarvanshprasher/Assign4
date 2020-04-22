//
//  PlaceTableViewController.swift
//  Assign4sprasher
//
//  Created by sarvansh prasher on 3/7/20.
//  Copyright © 2020 Sarvansh prasher. All rights reserved.
//  Rights to use this code given to Arizona State University
//  & Professor Timothy Lindquist (Tim.Lindquist@asu.edu) for course SER 423
//  @author Sarvansh Prasher mailto:sprasher@asu.edu
//  @version 7 March,2020

import UIKit

class PlaceTableViewController: UITableViewController {

    let controller = PlaceLibrary()
    var placesList:[String:PlaceDescription] = [String:PlaceDescription]()
    var names:[String] = [String]()
    var urlString:String = "http://127.0.0.1:8080"
    let placecoredata = PlaceCoreData();
    var isRefeshing = false
    
    @IBOutlet weak var placeTableListView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveData(_:)), name: .didReceiveData, object: nil)
        
        
//        let place = PlaceDescription()
//        place.name = "dsds new"
//        place.description = "desc"
//        place.category = "cat"
//        place.address_street = "as"
//        place.address_title = "at"
//        place.elevation = 22
//        place.latitude = 44
//        place.longitude = 66
////
//        placecoredata.addPlace(place: place)
//        placecoredata.getPlaces(viewController: self)
        
//        self.getPlacesData()
        
        
        
        
        
        let swipeToRefresh = UIRefreshControl()
        swipeToRefresh.addTarget(self, action: #selector(syncwithserver), for: .valueChanged)
        self.refreshControl = swipeToRefresh
        swipeToRefresh.attributedTitle = NSAttributedString(string: "Sync in progress...")
        
        
        self.title = "Places"
        self.urlString = self.setURL()
        loadDatafromDB()
  
    }
    
    @objc private func syncwithserver()  {
        isRefeshing = true;
        placecoredata.deleteAllPlaces()
        getPlacesData()
    }
    
    func loadDatafromDB(){
        let allplaces: Array<PlaceDescription> = placecoredata.getPlaces()
        
        var index = 0;
        for place in allplaces{
            
            names.append(place.name)
//            print()
//            names[index] = place.name
            
            index = index + 1
            placesList[place.name] = place
        }
        tableView.reloadData()
    }
    
    func getPlacesData() {
        let aConnect:PlaceCollectionAsyncTask = PlaceCollectionAsyncTask(urlString: urlString)
        let _:Bool = aConnect.getNames(callback: { (res: String, err: String?) -> Void in
            if err != nil {
                NSLog(err!)
            }else{
                NSLog(res)
                if let data: Data = res.data(using: String.Encoding.utf8){
                    do{
                        let dict = try JSONSerialization.jsonObject(with: data,options:.mutableContainers) as?[String:AnyObject]
                        self.names = (dict!["result"] as? [String])!
                        self.names = Array(self.names).sorted()
                        if self.names.count > 0 {
                            self.populateList(names: self.names)
                        }
                    } catch {
                        print("unable to convert to dictionary")
                    }
                }
                
            }
        })  // end of method call to getNames
    }
    
    func populateList( names:[String]){
        self.names = names
        for name in names{
            getDetails(name)
        }
        self.refreshControl?.endRefreshing()
        tableView.reloadData()
    }
    
    
    func getDetails(_ name: String){
        let aConnect:PlaceCollectionAsyncTask = PlaceCollectionAsyncTask(urlString: urlString)
        let _:Bool = aConnect.get(name: name, callback: { (res: String, err: String?) -> Void in
            if err != nil {
                NSLog(err!)
            }else{
                NSLog(res)
                if let data: Data = res.data(using: String.Encoding.utf8){
                    do{
                        let dict = try JSONSerialization.jsonObject(with: data,options:.mutableContainers) as?[String:AnyObject]
                        let aDict:[String:AnyObject] = (dict!["result"] as? [String:AnyObject])!
                        let place:PlaceDescription = PlaceDescription(dict: aDict)
                        self.placesList[name] = place
                        self.placecoredata.addPlace(place: place)
                    } catch {
                        NSLog("unable to convert to dictionary")
                    }
                }
            }
        })
    }

    
    func setURL () -> String {
        var serverhost:String = "localhost"
        var jsonrpcport:String = "8080"
        var serverprotocol:String = "http"
        // access and log all of the app settings from the settings bundle resource
        if let path = Bundle.main.path(forResource: "ServerInfo", ofType: "plist"){
            // defaults
            if let dict = NSDictionary(contentsOfFile: path) as? [String:AnyObject] {
                serverhost = (dict["server_host"] as? String)!
                jsonrpcport = (dict["jsonrpc_port"] as? String)!
                serverprotocol = (dict["server_protocol"] as? String)!
            }
        }
//        print("setURL returning: \(serverprotocol)://\(serverhost):\(jsonrpcport)")
        return "\(serverprotocol)://\(serverhost):\(jsonrpcport)"
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return names.count
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        print("tableView editing row at: \(indexPath.row)")
        if editingStyle == .delete {
            
            print("1 "+indexPath.row.description)
            
            let aConnect:PlaceCollectionAsyncTask = PlaceCollectionAsyncTask(urlString: urlString)
            let isdeleted = aConnect.remove(placeName: names[indexPath.row],callback: { _,_  in
            })
            
            print("2 "+indexPath.row.description)
            print("is deleted "+isdeleted.description)
            
            
            let selectedPlace:String = names[indexPath.row]
            
            placecoredata.deletePlace(placeName: selectedPlace)
            placesList.removeValue(forKey: selectedPlace)
            names = Array(placesList.keys)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get and configure the cell...
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceList", for: indexPath)
        let places =  names[indexPath.row] as String
//        let places = placesList[names[indexPath.row]]! as PlaceDescription
        cell.textLabel?.text = places
//        cell.detailTextLabel?.text = "\(places)"
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object (and model) to the new view controller.
        //NSLog("seque identifier is \(String(describing: segue.identifier))")
        if segue.identifier == "PlaceDetail" {
            let indexPath = self.tableView.indexPathForSelectedRow!
            let viewController:ViewController = segue.destination as! ViewController
            viewController.place = self.placesList
            viewController.selectedPlace = self.names[indexPath.row]
            viewController.placesNames = names
        }
    }
    
    @IBAction func unwindWithSegue(_ segue: UIStoryboardSegue) {
        
    }
    
    
    @objc func onDidReceiveData(_ notification:Notification) {
        
        guard let dic = notification.object as? PlaceDescription else {
            return
            }
        let newPlace:PlaceDescription = PlaceDescription(name: dic.name, description: dic.description,
                                        category: dic.category, address_title: dic.address_title,
                                        address_street: dic.address_street , elevation: dic.elevation,
                                        latitude: dic.latitude, longitude: dic.longitude)
        self.placesList[dic.name] = newPlace
        placecoredata.addPlace(place: newPlace)
        let aConnect:PlaceCollectionAsyncTask = PlaceCollectionAsyncTask(urlString: urlString)
        let _:Bool = aConnect.add(place: newPlace,callback: { _,_  in
            print("\(newPlace.name) added as: \(newPlace.toJsonString())")})
        self.names = Array(self.placesList.keys).sorted()
        self.tableView.reloadData()
    }
    
}
