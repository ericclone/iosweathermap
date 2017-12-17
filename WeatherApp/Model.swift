//
//  Model.swift
//  WeatherApp
//
//  Created by aa001 on 12/15/17.
//

import Foundation
import os.log

class Model {
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("cities")
    static let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=fd623f8c35e8cd6fb3da16fde390e33b&q=%@"
    static let forecastURL = "https://api.openweathermap.org/data/2.5/forecast?appid=fd623f8c35e8cd6fb3da16fde390e33b&q=%@"
    
    
    static let shared = Model()
    static var imperial: Bool = true {
        didSet {
            print("old value", oldValue, "new Value", imperial)
        }
    }
    private init() {}
    var cities: [City] = [City]()
    
    class func addCity(name: String, whenDone callback: @escaping () -> ()) -> Bool {
        let results = shared.cities.filter {$0.name == name}
        if !results.isEmpty {
            return false
        }
        let city = City()
        city.name = name
        shared.cities.append(city)
        
        if !updateWeather(cityIndex: shared.cities.count - 1, callback: callback) {
            return false
        }
        if !updateForecast(city: city) {
            return false
        }
        
        print(shared.cities.count)
        return true
    }
    
    class func updateWeather(cityIndex: Int, callback: @escaping () -> ()) -> Bool {
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
                    
                    let temperatures = json!["main"] as? [String: Any]
                    let low = temperatures!["temp_min"] as! Double
                    let high = temperatures!["temp_max"] as! Double
                    let temp = temperatures!["temp"] as! Double
                    
                    let currentWeather = Weather(temp: temp, high: high, low: low, main: main, icon: icon, timeComponents: [])
                    print(currentWeather!)
                    Model.shared.cities[cityIndex].current = currentWeather
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
        return true
    }
    
    class func updateForecast(city: City) -> Bool {
        return true
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
        if imperial {
            return Int((kelvin - 273.15) * 1.8 + 32)
        } else {
            return Int(kelvin - 273.15)
        }
    }
}
