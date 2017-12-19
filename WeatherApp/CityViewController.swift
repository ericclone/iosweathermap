//
//  MealViewController.swift
//  WeatherApp
//
//  Created by aa001 on 11/8/17.
//

import UIKit
import os.log

class CityViewController: UIViewController {
    
    // MARK: Properties
//    @IBOutlet weak var nameTextField: UITextField!
//    @IBOutlet weak var photoImageView: UIImageView!
//    @IBOutlet weak var ratingControl: RatingControl!
//    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    /*
     This value is either passed by `MealTableViewController` in `prepare(for:sender:)`
     or constructed as part of adding a new meal.
     */
    var city: City?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Set up views if editing an existing Meal.
        if let city = city {
            navigationItem.title = city.name
//            nameTextField.text   = meal.name
//            photoImageView.image = meal.photo
//            ratingControl.rating = meal.rating
        }
        
        // Enable the Save button only if the text field has a valid Meal name.
//        updateSaveButtonState()
    }
    
    
}

