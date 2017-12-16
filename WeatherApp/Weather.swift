//
//  Weather.swift
//  WeatherApp
//
//  Created by aa001 on 12/9/17.
//

//
//  Meal.swift
//  WeatherApp
//
//  Created by aa001 on 11/11/17.
//

import UIKit
import os.log

class Weather: NSObject, NSCoding {
    // MARK: Properties
    
    var temp: Double
    var high: Double
    var low: Double
    var main: String
    var icon: String
    var timeComponents: [String]
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("cities")
    
    // MARK: Types
    
    struct PropertyKey {
        static let temp = "temp"
        static let high = "high"
        static let low = "low"
        static let main = "main"
        static let icon = "icon"
        static let timeComponents = "timecomponents"
    }
    
    // MARK: Initialization
    
    init?(temp: Double, high: Double, low: Double, main: String, icon: String, timeComponents: [String]) {
        self.temp = temp
        self.high = high
        self.low = low
        self.main = main
        self.icon = icon
        self.timeComponents = timeComponents
    }
    
    // MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(temp, forKey: PropertyKey.temp)
        aCoder.encode(high, forKey: PropertyKey.high)
        aCoder.encode(low, forKey: PropertyKey.low)
        aCoder.encode(main, forKey: PropertyKey.main)
        aCoder.encode(icon, forKey: PropertyKey.icon)
        aCoder.encode(timeComponents, forKey: PropertyKey.timeComponents)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let temp = aDecoder.decodeDouble(forKey: PropertyKey.temp)
        let high = aDecoder.decodeDouble(forKey: PropertyKey.high)
        let low = aDecoder.decodeDouble(forKey: PropertyKey.low)
        let main = aDecoder.decodeObject(forKey: PropertyKey.main) as! String
        let icon = aDecoder.decodeObject(forKey: PropertyKey.icon) as! String
        let timeComponents = aDecoder.decodeObject(forKey: PropertyKey.timeComponents) as! [String]
        
        self.init(temp: temp, high: high, low: low, main: main, icon: icon, timeComponents: timeComponents)
    }
    
}

