//
//  WeatherForecastModel.swift
//  WeatherApp
//
//  Created by Manish Tamta on 23/05/2022.
//

import Foundation

typealias WeatherForecastList = [WeatherForecastModel]

// MARK: - WeatherForecastModel
struct WeatherDataModel: BaseModel {
    let data: WeatherForecastList?
    let cityName: String?
    let lon: Double?
    let lat: Double?
    
    enum CodingKeys: String, CodingKey {
        case data
        case cityName = "city_name"
        case lon, lat
    }
}

// MARK: - Datum
struct WeatherForecastModel: BaseModel, Hashable {
    
    var uniqueId:UUID? = UUID()
    var rh: Int?
    var pres, highTemp: Double?
    var sunsetTs: Int?
    var sunriseTs: Int?
    var appMinTemp, windSpd: Double?
    var windCdirFull: String?
    var appMaxTemp, vis: Double?
    var weather: WeatherDescription?
    var precip, lowTemp: Double?
    var datetime: String?
    var temp: Double?
    
    enum CodingKeys: String, CodingKey {
        case rh, pres
        case highTemp = "high_temp"
        case sunsetTs = "sunset_ts"
        case sunriseTs = "sunrise_ts"
        case appMinTemp = "app_min_temp"
        case windSpd = "wind_spd"
        case windCdirFull = "wind_cdir_full"
        case appMaxTemp = "app_max_temp"
        case vis, weather
        case precip
        case lowTemp = "low_temp"
        case datetime, temp
    }
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(uniqueId)
    }
    
    static func == (lhs: WeatherForecastModel, rhs: WeatherForecastModel) -> Bool {
        return lhs.uniqueId == rhs.uniqueId &&
        lhs.rh == rhs.rh &&
        lhs.pres == rhs.pres &&
        lhs.highTemp == rhs.highTemp &&
        lhs.sunsetTs == rhs.sunsetTs &&
        lhs.sunriseTs == rhs.sunriseTs &&
        lhs.appMinTemp == rhs.appMinTemp &&
        lhs.windSpd == rhs.windSpd &&
        lhs.windCdirFull == rhs.windCdirFull &&
        lhs.appMaxTemp == rhs.appMaxTemp &&
        lhs.vis == rhs.vis &&
        lhs.precip == rhs.precip &&
        lhs.lowTemp == rhs.lowTemp &&
        lhs.datetime == rhs.datetime &&
        lhs.temp == rhs.temp
    }
    
    var sunriseTime: String {
        if let value = sunriseTs {
            let sunriseTs = Double(value)
            let date = Date(timeIntervalSince1970: sunriseTs)
            return date.toString(format: .custom("HH:mm a"))
        }
        return datetime ?? ""
    }
    
    var sunsetTime: String {
        if let value = sunsetTs {
            let sunsetTs = Double(value)
            let date = Date(timeIntervalSince1970: sunsetTs)
            return date.toString(format: .custom("HH:mm a"))
        }
        return datetime ?? ""
    }
    
    lazy var dateInString: String = {
        if let dateStr = datetime {
            if let date = Date.init(fromString: dateStr, format: .isoDate){
                return date.toString(format: .custom("EEE\ndd MM"))
            }
        }
        return datetime ?? ""
    }()
    
    var date: Date? {
        if let dateStr = datetime {
            return Date.init(fromString: dateStr, format: .isoDate)
        }
        return nil
    }
    
    func getWeatherInfo()->[WeatherInfo]{
        return [
            WeatherInfo(title: "Wind speed", icon: "wind", value: TemperatureUnitManager.shared.formatValueUnit(self.windSpd, unit: .windSpeed)),
            WeatherInfo(title: "Wind direction", icon: "wind", value: self.windCdirFull),
            WeatherInfo(title: "Sunrise", icon: "sunrise", value: self.sunriseTime),
            WeatherInfo(title: "Sunset", icon: "sunset", value: self.sunsetTime),
            WeatherInfo(title: "Visibility", icon: "eye.fill", value: TemperatureUnitManager.shared.formatValueUnit(self.vis, unit: .visibility)),
            WeatherInfo(title: "Average pressure", icon: "stopwatch.fill", value: TemperatureUnitManager.shared.formatValueUnit(self.pres, unit: .pressure)),
            WeatherInfo(title: "Average relative humidity", icon: "humidity", value: TemperatureUnitManager.shared.formatValueUnit(Double(self.rh ?? 0), unit: .percent)),
            WeatherInfo(title: "Max Feels Like", icon: "thermometer", value: TemperatureUnitManager.shared.formatValueUnit(self.appMaxTemp, unit: .celcius)),
            WeatherInfo(title: "Min Feels Like", icon: "thermometer", value: TemperatureUnitManager.shared.formatValueUnit(self.appMinTemp, unit: .celcius)),
            WeatherInfo(title: "Accumulated liquid equivalent precipitation", icon: "aqi.medium", value: TemperatureUnitManager.shared.formatValueUnit(self.precip, unit: .precipitation)),
        ]

    }
}

// MARK: - Weather
struct WeatherDescription: Codable {
    let icon: String?
    let code: Int?
    let weatherDescription: String?

    enum CodingKeys: String, CodingKey {
        case icon, code
        case weatherDescription = "description"
    }
}

// MARK: - WeatherInfo
struct WeatherInfo: Hashable {
    var uuid = UUID()
    var title: String?
    var icon: String?
    var value: String?
    
    static func == (lhs: WeatherInfo, rhs: WeatherInfo) -> Bool {
        return lhs.uuid == rhs.uuid &&
        lhs.title == rhs.title &&
        lhs.icon == rhs.icon &&
        lhs.value == rhs.value
    }
}
