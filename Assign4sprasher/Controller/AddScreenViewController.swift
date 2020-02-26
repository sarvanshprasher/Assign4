//
//  AddScreenViewController.swift
//  Assign4sprasher
//
//  Created by sarvansh prasher on 2/26/20.
//  Copyright © 2020 Sarvansh prasher. All rights reserved.
//

import UIKit

class AddScreenViewController: UIViewController {

override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let identifier = segue.identifier else { return }
    
    switch identifier {
    case "save":
        print("save bar")
        
    case "cancel":
        print("cancel bar")
        
    default:
        print("unexpected segue identifier")
    }
}
}
