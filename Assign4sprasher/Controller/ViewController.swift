//
//  ViewController.swift
//  Assign4sprasher
//
//  Created by sarvansh prasher on 2/24/20.
//  Copyright © 2020 Sarvansh prasher. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate,
                        UINavigationControllerDelegate,UIPickerViewDataSource {
    
    var place:[String:PlaceDescription] = [String:PlaceDescription]()
    var selectedPlace:String = "unknown"
    var placesNames:[String] = [String]()
    

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
//    @IBOutlet weak var dummyBearing: UITextView!
//    @IBOutlet weak var dummyDistane: UITextView! 
    
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
        selectedPlace = placesNames[row]
        let tokens:[String] = selectedPlace.components(separatedBy: " ")
        self.selectPlace.text = tokens[0]
        print(selectPlace.text)
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
    
    


}

