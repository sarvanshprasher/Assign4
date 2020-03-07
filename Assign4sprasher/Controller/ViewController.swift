//
//  ViewController.swift
//  Assign4sprasher
//
//  Created by sarvansh prasher on 2/24/20.
//  Copyright © 2020 Sarvansh prasher. All rights reserved.
//

import UIKit
import Foundation
import Darwin

class ViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate,
                        UINavigationControllerDelegate,UIPickerViewDataSource {
    
    var place:[String:PlaceDescription] = [String:PlaceDescription]()
    var selectedPlace:String = "unknown"
    
    var placesNames:[String] = [String]()
    let zero = 0.0

    @IBOutlet weak var dummyName: UITextView!
    @IBOutlet weak var dummyDescription: UITextView!
    @IBOutlet weak var dummyCategory: UITextView!
    @IBOutlet weak var dummyAddressTitle: UITextView!
    @IBOutlet weak var dummyAddressStreet: UITextView!
    @IBOutlet weak var dummyElevation: UITextView!
    @IBOutlet weak var dummyLatitude: UITextView!
    @IBOutlet weak var dummyLongitude: UITextView!
    @IBOutlet weak var selectPlace: UITextField!
    @IBOutlet weak var placePicker: UIPickerView!
    @IBOutlet weak var dummyDistance: UITextView!
    @IBOutlet weak var dummyBearing: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dummyName.text = "\(place[selectedPlace]!.name)"
        dummyDescription.text = "\(place[selectedPlace]!.description)"
        dummyCategory.text = "\(place[selectedPlace]!.category)"
        dummyAddressTitle.text = "\(place[selectedPlace]!.address_title)"
        dummyAddressStreet.text = "\(place[selectedPlace]!.address_street)"
        dummyElevation.text = "\(place[selectedPlace]!.elevation)"
        dummyLatitude.text = "\(place[selectedPlace]!.latitude)"
        dummyLongitude.text = "\(place[selectedPlace]!.longitude)"
        dummyDistance.text = String(zero)
        dummyBearing.text = String(zero)

        
        self.title = place[selectedPlace]?.name
        
        
        placePicker.delegate = self
        placePicker.dataSource = self
        placePicker.removeFromSuperview()
        selectPlace.inputView = placePicker

        selectedPlace =  (placesNames.count > 0) ? placesNames[0] : "unknown unknown"
        let place:[String] = selectedPlace.components(separatedBy: " ")
        selectPlace.text = place[0]

       
    }
 
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.selectPlace.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.selectPlace.resignFirstResponder()
        return true
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let thisPlace = placesNames[row]
        let tokens:[String] = thisPlace.components(separatedBy: " ")
        self.selectPlace.text = tokens[0]
        print(place[thisPlace]!.longitude)
        print(place[thisPlace]!.latitude)
        
        let distance = getDistance(latitude: Double(place[thisPlace]!.latitude), longitude: Double(place[thisPlace]!.longitude))
        
        let bearing =  getBearing(latitude: Double(place[thisPlace]!.latitude), longitude: Double(place[thisPlace]!.longitude))
        
        dummyDistance.text = String(distance)
        
        dummyBearing.text = String(bearing)
        
        self.selectPlace.resignFirstResponder()
    }
    
    func pickerView (_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let p:String = placesNames[row]
        let tokens:[String] = p.components(separatedBy: " ")
        return tokens[0]
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return placesNames.count
    }
    
    func getDistance(latitude:Double, longitude :Double) -> Double {
    
        
        print(latitude,longitude)
        
    var lat1 = 0.0
    var lat2 = 0.0
    var lon1 = 0.0
    var lon2 = 0.0
    
    lat1 = Double(place[selectedPlace]!.latitude)
    lon1 = Double(place[selectedPlace]!.longitude)
        
     print(lat1,lon1)
    
    lat2 = latitude
    lon2 = longitude
    
    if ((lat1 == lat2) && (lon1 == lon2)) {
    return zero
    } else {
    let theta = lon1 - lon2
    var dist = sin(deg2rad(lat1)) * sin(deg2rad(lat2))
        + cos(deg2rad(lat1)) * cos(deg2rad(lat2))
        * cos(deg2rad(theta))
    dist = acos(dist)
    dist = radiansToDegrees(radians: dist)
    dist = dist * 60 * 1.1515 * 1.609344
    return (dist)
    }
    }
    
    func getBearing(latitude:Double, longitude :Double) -> Double {
    
    var lat1 = 0.0
    var lat2 = 0.0
    var lon1 = 0.0
    var lon2 = 0.0
    
    lat1 = Double(place[selectedPlace]!.latitude)
    lat1 = deg2rad(lat1)
    
    lon1 = Double(place[selectedPlace]!.longitude)

    lat2 = latitude
    lat2 = deg2rad(lat2)
    
    lon2 = longitude
    
        let longDiff = deg2rad(lon2 - lon1)
        let y = sin(longDiff) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(longDiff)
    
        return (radiansToDegrees(radians: atan2(y, x)) + 360).truncatingRemainder(dividingBy:360)
    }
    
    func deg2rad(_ number: Double) -> Double {
        return number * .pi / 180
    }
    
    func radiansToDegrees (radians: Double)->Double {
        return radians * 180 / .pi
    }

}

