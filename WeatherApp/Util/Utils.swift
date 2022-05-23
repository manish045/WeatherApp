//
//  Utils.swift
//  WeatherApp
//
//  Created by Manish Tamta on 23/05/2022.
//

import Foundation
import UIKit


extension UIView {
    func setCornerRadius(_ radius: CGFloat) {
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
    }
}

public enum UnitKey: String, Codable {
    case Fahrenheit = "I"
    case Celcius = "M"
    
    var title: String{
        switch self {
        case .Fahrenheit:
            return "F"
        case .Celcius:
            return "C"
        }
    }
    
    static let tempUnits :[UnitKey] = [.Celcius, .Fahrenheit]
}

class TemperatureUnitManager {
    
    public let generalUnit :UnitKey = .Celcius
    
    public private(set) var currentUnit :UnitKey!
    
    static var shared: TemperatureUnitManager = TemperatureUnitManager()

    fileprivate init(){
        self.currentUnit = .Celcius
    }
    
    func updateUnit(unit: UnitKey){
        currentUnit = unit
    }
    
    func calculateCelsius(fahrenheit: Double) -> Double {
        var celsius: Double
        
        celsius = (fahrenheit - 32) * 5 / 9
        
        return celsius
    }
    
    func calculateFahrenheit(celsius: Double) -> Double {
        var fahrenheit: Double
        
        fahrenheit = celsius * 9 / 5 + 32
        
        return fahrenheit
    }
    
    func getCurrentTemp(temp: Double)->String{
        var currentTemp :Double
        if currentUnit == generalUnit {
            currentTemp = temp
        }else if currentUnit == .Fahrenheit {
            currentTemp = calculateFahrenheit(celsius: temp)
        }else {
            currentTemp = calculateCelsius(fahrenheit: temp)
        }
        
        return "\(String(format: "%.2f", currentTemp)) °\(currentUnit.title)"
    }
    
    func formatValueUnit(_ value: Double?, unit: UnitKey)->String{
        return "\(value ?? 0) \(unit.title)"
    }
}
