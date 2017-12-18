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
    
    var temp: Double = 0
    var high: Double = 0
    var low: Double = 0
    var main: String = ""
    var icon: String = ""
    var time: TimeInterval? = 0
    var timeComponents: [String] = []
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("cities")
    
    // MARK: Types
    
    struct Key {
        static let temp = "temp"
        static let high = "high"
        static let low = "low"
        static let main = "main"
        static let icon = "icon"
        static let time = "time"
        static let timeComponents = "timecomponents"
    }
    
    // MARK: Initialization
    override init() {super.init()}
    
    init?(temp: Double, high: Double, low: Double, main: String, icon: String, time: TimeInterval?, timeComponents: [String]) {
        self.temp = temp
        self.high = high
        self.low = low
        self.main = main
        self.icon = icon
        self.time = time
        self.timeComponents = timeComponents
    }
    
    // MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(temp, forKey: Key.temp)
        aCoder.encode(high, forKey: Key.high)
        aCoder.encode(low, forKey: Key.low)
        aCoder.encode(main, forKey: Key.main)
        aCoder.encode(icon, forKey: Key.icon)
        aCoder.encode(time, forKey: Key.time)
        aCoder.encode(timeComponents, forKey: Key.timeComponents)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let temp = aDecoder.decodeDouble(forKey: Key.temp)
        let high = aDecoder.decodeDouble(forKey: Key.high)
        let low = aDecoder.decodeDouble(forKey: Key.low)
        let main = aDecoder.decodeObject(forKey: Key.main) as! String
        let icon = aDecoder.decodeObject(forKey: Key.icon) as! String
        let time = aDecoder.decodeObject(forKey: Key.time) as? TimeInterval
        let timeComponents = aDecoder.decodeObject(forKey: Key.timeComponents) as! [String]
        
        self.init(temp: temp, high: high, low: low, main: main, icon: icon, time: time, timeComponents: timeComponents)
    }
    
}

