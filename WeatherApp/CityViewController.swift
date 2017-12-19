//
//  MealViewController.swift
//  WeatherApp
//
//  Created by aa001 on 11/8/17.
//

import UIKit
import os.log

class CityViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let cityIndex = cityIndex {
            let count = Model.shared.cities[cityIndex].daily.count
            print("valid cityIndex with \(count) entries in section \(section)")
            return count
        } else {
            print("City View has no index")
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("DailyTableView called")
        // Table view cells are reused and should be dequeued using a cell identifier.
        
        let cellIdentifier = "DailyTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? DailyTableViewCell else {
            fatalError("The dequeued cell is not an instance of DailyTableViewCell.")
        }
        
        cell.dayLabel.text = "Day \(indexPath.row)"
        return cell
    }
    
    
    // MARK: Properties

    var cityIndex: Int?
    @IBOutlet weak var dailyTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGestures(gesture:)))
        swipeRight.direction = .right
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGestures(gesture:)))
        swipeLeft.direction = .left
        
        self.view.addGestureRecognizer(swipeRight)
        self.view.addGestureRecognizer(swipeLeft)
        
        dailyTableView.dataSource = self
        dailyTableView.delegate = self
        
        updateUI()
    }
    
    private func updateUI() {
        
        // Set up views if editing an existing Meal.
        if let cityIndex = cityIndex {
            let city = Model.shared.cities[cityIndex]
            var cityName = city.name
            if cityName == Model.cityName {
                cityName += " 📍"
                view.backgroundColor = UIColor(red: 0.8, green: 1.0, blue: 0.8, alpha: 0.8)
            } else {
                view.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 1.0, alpha: 0.8)
            }
            navigationItem.title = cityName
        }
    }
    
    @objc func respondToSwipeGestures(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case .right:
                if cityIndex != Model.shared.cities.count - 1 {
                    cityIndex! += 1
                }
                print("swipe right \(String(describing: cityIndex))")
            case .left:
                if cityIndex != 0 {
                    cityIndex! -= 1
                }
                print("swipe left \(String(describing: cityIndex))")
            default:
                break
            }
        }
        updateUI()
    }
    
}

