//
//  AddScreenViewController.swift
//  Assign4sprasher
//
//  Created by sarvansh prasher on 3/7/20.
//  Copyright © 2020 Sarvansh prasher. All rights reserved.
//  Rights to use this code given to Arizona State University
//  & Professor Timothy Lindquist (Tim.Lindquist@asu.edu) for course SER 423
//  @author Sarvansh Prasher mailto:sprasher@asu.edu
//  @version 7 March,2020

import UIKit

class AddScreenViewController: UIViewController {
    
    @IBOutlet weak var answerName: UITextField!
    @IBOutlet weak var answerDescription: UITextField!
    @IBOutlet weak var answerCategory: UITextField!
    @IBOutlet weak var answerAddressTitle: UITextField!
    @IBOutlet weak var answerAddressStreet: UITextField!
    @IBOutlet weak var answerElevation: UITextField!
    @IBOutlet weak var answerLatitude: UITextField!
    @IBOutlet weak var answerLongitude: UITextField!
    
    
    var place:PlaceDescription!
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case "save":
            setValuesForPlace(answerName: (answerName.text ?? nil)!,answerDescription: (answerDescription.text ?? nil)!,answerCategory: (answerCategory.text ?? nil)!,answerAddressTitle: (answerAddressTitle.text ?? nil)!, answerAddressStreet: (answerAddressStreet.text ?? nil)!,
                              answerElevation: (answerElevation.text! as NSString).floatValue,answerLatitude: (answerLatitude.text! as NSString).floatValue,answerLongitude: (answerLongitude.text! as NSString).floatValue)
            print("save bar item")
            
        case "cancel":
            print("cancel bar item")
            
        default:
            print("unexpected segue identifier")
        }
    }
    
    func setValuesForPlace(answerName: String,answerDescription : String,answerCategory : String,
                           answerAddressTitle: String, answerAddressStreet : String,answerElevation :Float,
                           answerLatitude: Float, answerLongitude: Float){
        
        
        place = PlaceDescription(name: answerName,description: answerDescription,category: answerCategory,address_title: answerAddressTitle,
                                 address_street: answerAddressStreet,elevation: answerElevation,latitude: answerLatitude,longitude: answerLongitude)
        
        NotificationCenter.default.post(name: .didReceiveData, object: place)
        
    }
    
}

public extension Notification.Name {
    static let didReceiveData = Notification.Name("didReceiveData")
}
