//
//  MealTableViewController.swift
//  WeatherApp
//
//  Created by aa001 on 11/11/17.
//

import UIKit
import GooglePlaces
import os.log

class CityTableViewController: UITableViewController, CLLocationManagerDelegate {
    
    // MARK: Properties
    
    var meals = [Meal]()
    let manager = CLLocationManager()
    
    @IBOutlet weak var unitButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem

        Model.addCity(name: "San Jose", lat: 37.3382, lon: -121.8863, whenDone: handleResult)
        Model.addCity(name: "San Francisco", lat: 37.7749, lon: -122.4194, whenDone: handleResult)
        Model.addCity(name: "Beijing", lat: 39.9042, lon: 116.4074, whenDone: handleResult)
//        tableView.reloadData()
        
        unitButton.title = Model.metric ? "℃" : "℉"
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Handle result
    
    func handleResult(_ success: Bool, _ message: String = "") {
        tableView.reloadData()
        if !success {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("tableView try to get count", Model.shared.cities.count)
        return Model.shared.cities.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        
        let cellIdentifier = "CityTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CityTableViewCell else {
            fatalError("The dequeued cell is not an instance of CityTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let city = Model.shared.cities[indexPath.row]
        var cityName = city.name
        print("Model: \(Model.cityName), List: \(city.name)")
        if Model.cityName == city.name {
            cell.backgroundColor = UIColor(red: 0.8, green: 1.0, blue: 0.8, alpha: 0.8)
            cityName += " 📍"
//        } else if indexPath.row % 2 == 0{
//            cell.backgroundColor = UIColor.white
        } else {
            cell.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        }

        cell.nameLabel.text = cityName
        if let current = city.current {
            cell.iconImageView.image = UIImage(named: current.icon)
            cell.tempLabel.text = "\(Model.temp(current.temp))"
            
            let timeComponents = current.timeComponents
            cell.timeLabel.text = "\(timeComponents[4]):\(timeComponents[5]) \(timeComponents[6])"
        }

        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            Model.shared.cities.remove(at: indexPath.row)
//            saveMeals()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
        case "ShowDetail":
            guard let cityDetailViewController = segue.destination as? CityViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedCityCell = sender as? CityTableViewCell else {
                fatalError("Unexpected sender: \(sender ?? "nil - nil")")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedCityCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            

            cityDetailViewController.cityIndex = indexPath.row
        default:
            fatalError("Unexpected Segue Identifier: \(segue.identifier ?? "nil - nil")")
        }
    }


    // MARK: Actions
    @IBAction func addCity(_ sender: UIBarButtonItem) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.autocompleteFilter = GMSAutocompleteFilter()
        autocompleteController.autocompleteFilter?.type = .city
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }

    @IBAction func switchUnit(_ sender: UIBarButtonItem) {
        Model.metric = !Model.metric
        sender.title = Model.metric ? "℃" : "℉"
        tableView.reloadData()
    }
    
    // MARK: LocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        Model.updateLocation(location, completion: handleResult)
        
    }
    
    // MARK: Private Methods
    
    private func loadSampleMeals() {
        let photo1 = UIImage(named: "meal1")
        let photo2 = UIImage(named: "meal2")
        let photo3 = UIImage(named: "meal3")
        
        guard let meal1 = Meal(name: "Caprese Salad", photo: photo1, rating: 4) else {
            fatalError("Unable to instantiate meal1")
        }

        guard let meal2 = Meal(name: "Chicken and Potatoes", photo: photo2, rating: 5) else {
            fatalError("Unable to instantiate meal2")
        }

        guard let meal3 = Meal(name: "Pasta with Meatballs", photo: photo3, rating: 3) else {
            fatalError("Unable to instantiate meal3")
        }

        meals += [meal1, meal2, meal3]
    }
    
//    private func saveMeals() {
//        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(meals, toFile: Meal.ArchiveURL.path)
//        if isSuccessfulSave {
//            os_log("Meals successfully saved.", log: OSLog.default, type: .debug)
//        }
//        else {
//            os_log("Failed to save meals...", log: OSLog.default, type: .error)
//        }
//    }
//
//    private func loadMeals() -> [Meal]? {
//        return NSKeyedUnarchiver.unarchiveObject(withFile: Meal.ArchiveURL.path) as? [Meal]
//    }
}


//Google auto complete
extension CityTableViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place name: \(place.coordinate)")
        dismiss(animated: true, completion: nil)
        let name = place.name
        let lat = place.coordinate.latitude
        let lon = place.coordinate.longitude
        Model.addCity(name: name, lat: lat, lon: lon, whenDone: handleResult)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
