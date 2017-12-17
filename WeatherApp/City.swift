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
    var current: Weather?
    var hourly: [Weather]?
    var daily: [Weather]?
    var lastRealtime: TimeInterval = 0.0
    var lastForecast: TimeInterval = 0.0
    
    struct PropertyKey {
        static let name = "name"
        static let lat = "lat"
        static let lon = "lon"
        static let current = "current"
        static let hourly = "hourly"
        static let daily = "daily"
        static let lastRealTime = "lastrealtime"
        static let lastForecast = "lastforecast"
    }
    
    // MARK: Initialization
    override init() {}
    
    init(name: String, lat: Double, lon: Double, current: Weather?, hourly: [Weather]?, daily: [Weather]?, lastRealTime: TimeInterval?, lastForecast: TimeInterval?) {
        self.name = name
        self.lat = lat
        self.lon = lon
        self.current = current
        self.hourly = hourly
        self.daily = daily
        self.lastRealtime = lastRealTime ?? 0
        self.lastForecast = lastForecast ?? 0
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(lat, forKey: PropertyKey.lat)
        aCoder.encode(lon, forKey: PropertyKey.lon)
        aCoder.encode(current, forKey: PropertyKey.current)
        aCoder.encode(hourly, forKey: PropertyKey.hourly)
        aCoder.encode(daily, forKey: PropertyKey.daily)
        aCoder.encode(lastRealtime, forKey: PropertyKey.lastRealTime)
        aCoder.encode(lastForecast, forKey: PropertyKey.lastForecast)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String
        let lat = aDecoder.decodeDouble(forKey: PropertyKey.lat)
        let lon = aDecoder.decodeDouble(forKey: PropertyKey.lon)
        let current = aDecoder.decodeObject(forKey: PropertyKey.current) as? Weather
        let hourly = aDecoder.decodeObject(forKey: PropertyKey.hourly) as? [Weather]
        let daily = aDecoder.decodeObject(forKey: PropertyKey.daily) as? [Weather]
        let lastRealTime = aDecoder.decodeObject(forKey: PropertyKey.lastRealTime) as? TimeInterval
        let lastForecast = aDecoder.decodeObject(forKey: PropertyKey.lastForecast) as? TimeInterval
        self.init(name: name!, lat: lat, lon: lon, current: current, hourly: hourly, daily: daily, lastRealTime: lastRealTime, lastForecast: lastForecast)
        
    }
    
    
    
}
