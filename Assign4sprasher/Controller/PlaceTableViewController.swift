//
//  PlaceTableViewController.swift
//  Assign4sprasher
//
//  Created by sarvansh prasher on 2/25/20.
//  Copyright © 2020 Sarvansh prasher. All rights reserved.
//

import UIKit

class PlaceTableViewController: UITableViewController {

    var placesList:[String:PlaceDescription] = [String:PlaceDescription]()
    var names:[String] = [String]()
    
    @IBOutlet weak var placeTableListView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(PlaceTableViewController.addPlace))
        
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
        
        self.names = Array(placesList.keys).sorted()
        self.title = "Places"
        
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
            let selectedPlace:String = names[indexPath.row]
            placesList.removeValue(forKey: selectedPlace)
            names = Array(placesList.keys)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get and configure the cell...
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceList", for: indexPath)
        let places = placesList[names[indexPath.row]]! as PlaceDescription
        cell.textLabel?.text = places.name
        cell.detailTextLabel?.text = "\(places.category)"
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object (and model) to the new view controller.
        //NSLog("seque identifier is \(String(describing: segue.identifier))")
        if segue.identifier == "PlaceDetail" {
            let viewController:ViewController = segue.destination as! ViewController
            let indexPath = self.tableView.indexPathForSelectedRow!
            viewController.place = self.placesList
            viewController.selectedPlace = self.names[indexPath.row]
        }
    }
    

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

}
