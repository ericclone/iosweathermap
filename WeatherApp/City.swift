//
//  City.swift
//  WeatherApp
//
//  Created by aa001 on 12/11/17.
//

import Foundation

class City: NSObject, NSCoding {
    var name: String = ""
    var lat: Double = 0.0
    var lon: Double = 0.0
    var timeZone: TimeZone?
    var current: Weather?
    var hourly: [Weather]?
    var daily: [Weather]?
    var lastRealtime: TimeInterval = 0.0
    var lastForecast: TimeInterval = 0.0
    
    struct Key {
        static let name = "name"
        static let lat = "lat"
        static let lon = "lon"
        static let timeZone = "timezone"
        static let current = "current"
        static let hourly = "hourly"
        static let daily = "daily"
        static let lastRealTime = "lastrealtime"
        static let lastForecast = "lastforecast"
    }
    
    // MARK: Initialization
    override init() {}
    
    init(name: String, lat: Double, lon: Double, timeZone: TimeZone?, current: Weather?, hourly: [Weather]?, daily: [Weather]?, lastRealTime: TimeInterval?, lastForecast: TimeInterval?) {
        self.name = name
        self.lat = lat
        self.lon = lon
        self.timeZone = timeZone
        self.current = current
        self.hourly = hourly
        self.daily = daily
        self.lastRealtime = lastRealTime ?? 0
        self.lastForecast = lastForecast ?? 0
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: Key.name)
        aCoder.encode(lat, forKey: Key.lat)
        aCoder.encode(lon, forKey: Key.lon)
        aCoder.encode(timeZone, forKey: Key.timeZone)
        aCoder.encode(current, forKey: Key.current)
        aCoder.encode(hourly, forKey: Key.hourly)
        aCoder.encode(daily, forKey: Key.daily)
        aCoder.encode(lastRealtime, forKey: Key.lastRealTime)
        aCoder.encode(lastForecast, forKey: Key.lastForecast)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: Key.name) as? String
        let lat = aDecoder.decodeDouble(forKey: Key.lat)
        let lon = aDecoder.decodeDouble(forKey: Key.lon)
        let timeZone = aDecoder.decodeObject(forKey: Key.timeZone) as? TimeZone
        let current = aDecoder.decodeObject(forKey: Key.current) as? Weather
        let hourly = aDecoder.decodeObject(forKey: Key.hourly) as? [Weather]
        let daily = aDecoder.decodeObject(forKey: Key.daily) as? [Weather]
        let lastRealTime = aDecoder.decodeObject(forKey: Key.lastRealTime) as? TimeInterval
        let lastForecast = aDecoder.decodeObject(forKey: Key.lastForecast) as? TimeInterval
        self.init(name: name!, lat: lat, lon: lon, timeZone: timeZone, current: current, hourly: hourly, daily: daily, lastRealTime: lastRealTime, lastForecast: lastForecast)
        
    }
    
    
    
}
