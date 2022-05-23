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
    let data: WeatherForecastList

    enum CodingKeys: String, CodingKey {
        case data
    }
}

// MARK: - Datum
struct WeatherForecastModel: Hashable ,BaseModel {
    
    var uniqueId:UUID? = UUID()
    var weather: Weather?
    var lowTemp: Double?
    var datetime: String?
    var temp: Double?

    enum CodingKeys: String, CodingKey {
        case weather
        case lowTemp = "low_temp"
        case datetime, temp
    }
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(uniqueId)
    }
    
    static func == (lhs: WeatherForecastModel, rhs: WeatherForecastModel) -> Bool {
        return lhs.uniqueId == rhs.uniqueId &&
        lhs.lowTemp == rhs.lowTemp &&
        lhs.datetime == rhs.datetime &&
        lhs.temp == rhs.temp
    }
}

// MARK: - Weather
struct Weather: Codable {
    let icon: String
    let code: Int
    let weatherDescription: String

    enum CodingKeys: String, CodingKey {
        case icon, code
        case weatherDescription = "description"
    }
}
