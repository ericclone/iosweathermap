//
//  Model.swift
//  WeatherApp
//
//  Created by aa001 on 12/15/17.
//

import Foundation
import CoreLocation
import Contacts // for getting postalAddress from CLPlacemark
import os.log

class Model {
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("cities")
    static let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=fd623f8c35e8cd6fb3da16fde390e33b&q=%@"
    static let forecastURL = "https://api.openweathermap.org/data/2.5/forecast?appid=fd623f8c35e8cd6fb3da16fde390e33b&q=%@"
    
    
    static let shared = Model()
    
    static var cityName: String = ""
    
    static var metric: Bool = false {
        didSet {
            UserDefaults.standard.set(metric, forKey: "metric")
        }
    }
    
    var cities: [City] = [City]()
    
    private init() {}
    
    class func addCity(name: String, lat: Double, lon: Double, whenDone callback: @escaping () -> ()){
        let results = shared.cities.filter {$0.name == name}
        if !results.isEmpty {
            return
        }
        let city = City()
        city.name = name
        city.lat = lat
        city.lon = lon
        print(lat, lon)
        let index = shared.cities.count
        shared.cities.append(city)
        
        updateTimeZone(cityIndex: index, callback: callback)
        updateWeather(cityIndex: index, callback: callback)
        updateForecast(cityIndex: index, callback: callback)
    }
    
    class func updateTimeZone(cityIndex: Int, callback: @escaping () -> ()) {
        let city = shared.cities[cityIndex]
        if city.timeZone != nil {
            return
        }
        let location = CLLocation(latitude: city.lat, longitude: city.lon)
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
            if error == nil {
                print("before ", location, cityIndex, city.name, city.lat, city.lon, placemarks?.count)
                let firstLocation = placemarks?[0]
                let timeZone = firstLocation?.timeZone
                print(firstLocation?.postalAddress) 
                shared.cities[cityIndex].timeZone = timeZone
                print("after ", location, cityIndex, city.name, city.lat, city.lon, timeZone)
                DispatchQueue.main.async {
                    callback()
                }
            }
        })
    }
    
    class func updateWeather(cityIndex: Int, force: Bool = false, callback: @escaping () -> ()){
        print("updating weather")
        let urlString = String(format:Model.weatherURL, shared.cities[cityIndex].name)
        let escapedUrlString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let url = URL(string: escapedUrlString!)
        var errorMsg = ""
        let task = URLSession.shared.dataTask(with: url!) {
            (data, response, error) in
            print("received response")
            if error != nil {
                print(error!)
                errorMsg = error!.localizedDescription
            } else {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
                    
                    let weatherList = json!["weather"] as? [[String: Any]]
                    let weather = weatherList![0]
                    let main = weather["main"] as! String
                    let icon = weather["icon"] as! String
                    let time = json!["dt"] as! TimeInterval
                    
                    let temperatures = json!["main"] as? [String: Any]
                    let low = temperatures!["temp_min"] as! Double
                    let high = temperatures!["temp_max"] as! Double
                    let temp = temperatures!["temp"] as! Double
                    
                    let currentWeather = Weather(temp: temp, high: high, low: low, main: main, icon: icon, time: time, timeComponents: [])
                    print(currentWeather!)
                    shared.cities[cityIndex].current = currentWeather
                    shared.cities[cityIndex].lastRealtime = Date().timeIntervalSince1970
                    DispatchQueue.main.async {
                        callback()
                    }
                } catch let error as Error {
                    print(error)
                    errorMsg = error.localizedDescription
                }
            }
        }
        if errorMsg != "" {
            print(errorMsg)
        }
        task.resume()
    }
    
    class func updateForecast(cityIndex: Int, force: Bool = false, callback: @escaping () -> ()) {
        
    }
    
    class func updateLocation(_ location: CLLocation, completion callback: @escaping () -> ()) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
            if error == nil {
                let firstLocation = placemarks?[0]
                if let cityName = firstLocation?.postalAddress?.city {
                    Model.cityName = cityName
                }
                DispatchQueue.main.async {
                    callback()
                }
            }
        })
    }
    
    func updateAll() {
        let timeString = String(format: "The current time is %02d:%02d", 10, 4)
        print(timeString)
    }
    
    func save() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(cities, toFile: Model.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Cities successfully saved.", log: OSLog.default, type: .debug)
        }
        else {
            os_log("Failed to save Cities...", log: OSLog.default, type: .error)
        }
    }
    
    func load() {
        if let cities = NSKeyedUnarchiver.unarchiveObject(withFile: Model.ArchiveURL.path) as? [City] {
            self.cities = cities
        }
    }
    
    class func temp(_ kelvin: Double) -> Int {
        if metric {
            return Int(kelvin - 273.15)
        } else {
            return Int((kelvin - 273.15) * 1.8 + 32)
        }
    }
}
