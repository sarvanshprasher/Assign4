//
//  PlaceCoredata.swift
//  Assign4sprasher
//
//  Created by Rohit  on 22/04/20.
//  Copyright © 2020 Sarvansh prasher. All rights reserved.
//

import UIKit
import Foundation
import CoreData


class PlaceCoreData{
    
    var appDeledate : AppDelegate?
    var context: NSManagedObjectContext?
    
    init(){
        appDeledate = UIApplication.shared.delegate as! AppDelegate
        context = appDeledate!.persistentContainer.viewContext
    }
    
    func getPlaces(viewController: UITableViewController){
        
        let fetchPlacesRequest:NSFetchRequest<PlaceTable> = PlaceTable.fetchRequest()
        var places = Array<PlaceDescription>()
        
        do{
            let results = try context!.fetch(fetchPlacesRequest)
            NSLog("Places loaded \(results.count)")
            for result in results{
                let place: PlaceDescription = PlaceDescription()
                place.name = ((result as AnyObject).value(forKey:"name") as? String)!
                place.description = ((result as AnyObject).value(forKey:"place_description") as? String)!
                place.category = ((result as AnyObject).value(forKey:"category") as? String)!
                place.address_title = ((result as AnyObject).value(forKey:"address_title") as? String)!
                place.address_street = ((result as AnyObject).value(forKey:"address_street") as? String)!
                place.elevation = ((result as AnyObject).value(forKey:"elevation") as? Float)!
                place.latitude = ((result as AnyObject).value(forKey:"latitude") as? Float)!
                place.longitude = ((result as AnyObject).value(forKey:"longitude") as? Float)!
                places.append(place)
            }
            
            PlaceLibrary.setPlaces(allplaces: places)
            viewController.tableView.reloadData()
            NSLog("Places loaded \(results.count)")
            
        }catch let error as NSError{
            NSLog("Error fetching places \(error)")
        }
    }
    
    func addPlace(place: PlaceDescription){
        let entity = NSEntityDescription.entity(forEntityName: "PlaceTable", in: context!)
        let placetable = NSManagedObject(entity: entity!, insertInto: context)
        placetable.setValue(place.name, forKey: "name")
        placetable.setValue(place.description, forKey: "place_description")
        placetable.setValue(place.category, forKey: "category")
        placetable.setValue(place.address_title, forKey: "address_title")
        placetable.setValue(place.address_street, forKey: "address_street")
        placetable.setValue(place.elevation, forKey: "elevation")
        placetable.setValue(place.latitude, forKey: "latitude")
        placetable.setValue(place.longitude, forKey: "longitude")
        saveContext()
    }
    
    func addAllPlacesToDatabase(places: Array<PlaceDescription>){
        for place in places{
            addPlace(place: place)
        }
    }
    
    func updatePlace(oldName: String, place: PlaceDescription) {
        
        NSLog("updating place \(oldName)")
        let selectRequest:NSFetchRequest<PlaceTable> = PlaceTable.fetchRequest()
        selectRequest.predicate = NSPredicate(format:"name == %@",oldName)
        
        do{
            let results = try context!.fetch(selectRequest)
            NSLog("result \(results.count)")
            if results.count > 0 {
                let placetable = results[0] as NSManagedObject
                placetable.setValue(place.name, forKey: "name")
                placetable.setValue(place.description, forKey: "place_description")
                placetable.setValue(place.category, forKey: "category")
                placetable.setValue(place.address_title, forKey: "address_title")
                placetable.setValue(place.address_street, forKey: "address_street")
                placetable.setValue(place.elevation, forKey: "elevation")
                placetable.setValue(place.latitude, forKey: "latitude")
                placetable.setValue(place.longitude, forKey: "longitude")
                NSLog("updating place \(place.name)")
                saveContext()
            }
        } catch let error as NSError{
            NSLog("error updating place \(place.name). Error \(error)")
        }
        
    }
    
//    func deletePlace(placeName:String) -> Bool {
//        
//        var ret:Bool = false
//        let selectRequest:NSFetchRequest<Place> = Place.fetchRequest()
//        selectRequest.predicate = NSPredicate(format:"name == %@",placeName)
//        
//        do{
//            let results = try context!.fetch(selectRequest)
//            if results.count > 0 {
//                context!.delete(results[0] as NSManagedObject)
//                ret = true
//                saveContext()
//            }
//        } catch let error as NSError{
//            NSLog("error deleting student \(placeName). Error \(error)")
//        }
//        return ret
//    }
//    
//    func deleteAllPlaces(){
//        
//        let fetchRequest: NSFetchRequest<Place>  = Place.fetchRequest()
//        
//        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
//        
//        do {
//            try context!.execute(batchDeleteRequest)
//            
//        } catch {
//            // Error Handling
//        }
//        
//        saveContext()
//        
//    }
    
    func saveContext() -> Bool {
        var ret:Bool = false
        do{
            try context!.save()
            ret = true
        }catch let error as NSError{
            print("error saving context \(error)")
        }
        return ret
    }
}
