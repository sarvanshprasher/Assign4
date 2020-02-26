//
//  ViewController.swift
//  Assign4sprasher
//
//  Created by sarvansh prasher on 2/24/20.
//  Copyright © 2020 Sarvansh prasher. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var place:[String:PlaceDescription] = [String:PlaceDescription]()
    var selectedPlace:String = "unknown"
    

    @IBOutlet weak var dummyName: UITextView!
    @IBOutlet weak var dummyDescription: UITextView!
    @IBOutlet weak var dummyCategory: UITextView!
    @IBOutlet weak var dummyAddressTitle: UITextView!
    @IBOutlet weak var dummyAddressStreet: UITextView!
    @IBOutlet weak var dummyElevation: UITextView!
    @IBOutlet weak var dummyLatitude: UITextView!
    @IBOutlet weak var dummyLongitude: UITextView!
    
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
    }


}

