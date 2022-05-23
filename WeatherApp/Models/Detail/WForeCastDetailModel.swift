//
//  WForeCastDetailModel.swift
//  WeatherApp
//
//  Created by Manish Tamta on 23/05/2022.
//

import Foundation

struct WeatherDetailInfoModel: Hashable {
    var uuid = UUID()
    var dateTime: String?
    var cityName: String?
    var temp: Double?
    var lowTemp: Double?
    var highTemp: Double?
    var weather: Weather?
    
    static func == (lhs: WeatherDetailInfoModel, rhs: WeatherDetailInfoModel) -> Bool {
        return lhs.uuid == rhs.uuid &&
        lhs.dateTime == rhs.dateTime &&
        lhs.cityName == rhs.cityName &&
        lhs.temp == rhs.temp &&
        lhs.lowTemp == rhs.lowTemp &&
        lhs.highTemp == rhs.highTemp
    }
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(uuid)
    }
}
