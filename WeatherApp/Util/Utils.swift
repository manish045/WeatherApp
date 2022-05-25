//
//  Utils.swift
//  WeatherApp
//
//  Created by Manish Tamta on 23/05/2022.
//

import Foundation
import UIKit
import Combine

extension UIView {
    func setCornerRadius(_ radius: CGFloat) {
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
    }
}

public enum UnitKey: String, Codable {
    case fahrenheit = "I"
    case celcius = "M"
    case windSpeed = "m/s"
    case visibility = "KM"
    case pressure = "mb"
    case percent = "%"
    case precipitation = "mm"
    
    var title: String{
        switch self {
        case .fahrenheit:
            return "F"
        case .celcius:
            return "C"
        default:
            return self.rawValue
        }
    }
    
    static let tempUnits :[UnitKey] = [.celcius, .fahrenheit]
}

protocol TemperatureDelegate {
    var changeInTempUnit: Published<UnitKey?>.Publisher { get }
    func updateUnit(unit: UnitKey)
}

class TemperatureUnitManager: TemperatureDelegate {
    
    let generalUnit :UnitKey = .celcius
    
    @Published public private(set) var currentUnit :UnitKey!
    private var dafault = UserDefaultsManager.shared
    
    static var shared: TemperatureUnitManager = TemperatureUnitManager()
    
    var changeInTempUnit: Published<UnitKey?>.Publisher {$currentUnit}

    fileprivate init(){
        if let currentUnit = dafault.loadObject(forKey: .tempUnit) as? String{
            self.currentUnit = UnitKey(rawValue: currentUnit)
        }else {
            self.currentUnit = generalUnit
            dafault.saveObject(self.currentUnit.rawValue, key: .tempUnit)
        }
    }
    
    func updateUnit(unit: UnitKey){
        dafault.saveObject(unit.rawValue, key: .tempUnit)
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
        }else if currentUnit == .fahrenheit {
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
