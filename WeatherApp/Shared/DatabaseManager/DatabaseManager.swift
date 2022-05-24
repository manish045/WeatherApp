//
//  DatabaseManager.swift
//  WeatherApp
//
//  Created by Manish Tamta on 24/05/2022.
//

import Foundation
import RealmSwift

class DatabaseManager {
    
    static let shared: DatabaseManager = {
        let instance = DatabaseManager()
        // setup code
        return instance
    }()
    
    private init() {}
    
    var weatherForcastRealm: Realm {
        // Open the realm with a specific file URL, for example a username
        let type = "WeatherForcast"
        var config = Realm.Configuration.defaultConfiguration
        config.fileURL!.deleteLastPathComponent()
        config.fileURL!.appendPathComponent(type)
        config.fileURL!.appendPathExtension("realm")
        let realm = try! Realm(configuration: config)
        return realm
    }
    
    //Remove all stored WeatherForecast Data from storage
    func removeAllWeatherForecastData() {
        do {
            try weatherForcastRealm.write {
                weatherForcastRealm.deleteAll()
            }
        } catch let error as NSError {
            // Handle error
            print(error)
        }
    }
    
    //Save the updated or new WeatherForecastList
    func saveWeatherList(weatherForecastList :WeatherForecastList){
        do {
            let storableWeatherList = weatherForecastList.compactMap{ ($0).toStorable() }

            try  weatherForcastRealm.write {
                weatherForcastRealm.add(storableWeatherList)
            }
        } catch let error as NSError {
            // Handle error
            print("Error saving forecast data")
            print(error)
        }
        
    }
}
