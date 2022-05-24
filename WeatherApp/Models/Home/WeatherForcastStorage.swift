//
//  WeatherForcastStorage.swift
//  WeatherApp
//
//  Created by Manish Tamta on 24/05/2022.
//

import Foundation
import RealmSwift

extension WeatherForecastModel: Entity {

    private var storableWeatherForecast: StorableWeatherForecast {
        let realmWeatherForecast = StorableWeatherForecast()
        realmWeatherForecast.rh = rh
        realmWeatherForecast.pres = pres
        realmWeatherForecast.highTemp = highTemp
        realmWeatherForecast.sunsetTs = sunsetTs
        realmWeatherForecast.sunriseTs = sunriseTs
        realmWeatherForecast.appMinTemp = appMinTemp
        realmWeatherForecast.windSpd = windSpd
        realmWeatherForecast.windCdirFull = windCdirFull
        realmWeatherForecast.appMaxTemp = appMaxTemp
        realmWeatherForecast.vis = vis
        realmWeatherForecast.weather = weather?.toStorable()
        realmWeatherForecast.precip = precip
        realmWeatherForecast.lowTemp = lowTemp
        realmWeatherForecast.datetime = datetime
        realmWeatherForecast.temp = temp
        return realmWeatherForecast
    }
    
    func toStorable() -> StorableWeatherForecast {
        return storableWeatherForecast
    }
}

class StorableWeatherForecast: Object, Storable {
    @Persisted var rh: Int?
    @Persisted var pres: Double?
    @Persisted var highTemp: Double?
    @Persisted var sunsetTs: Int?
    @Persisted var sunriseTs: Int?
    @Persisted var appMinTemp: Double?
    @Persisted var windSpd: Double?
    @Persisted var windCdirFull: String?
    @Persisted var appMaxTemp: Double?
    @Persisted var vis: Double?
    @Persisted var weather: StorableWeatherDetails?
    @Persisted var precip: Double?
    @Persisted var lowTemp: Double?
    @Persisted var datetime: String?
    @Persisted var temp: Double?
    @Persisted var uuid: String = ""

    var model: WeatherForecastModel {
        get {
            return WeatherForecastModel(
                rh: rh,
                pres: pres,
                highTemp: highTemp,
                sunsetTs: sunsetTs,
                sunriseTs: sunriseTs,
                appMinTemp: appMinTemp,
                windSpd: windSpd,
                windCdirFull: windCdirFull,
                appMaxTemp: appMaxTemp,
                vis: vis,
                weather: weather?.model,
                precip: precip,
                lowTemp: lowTemp,
                datetime: datetime,
                temp: temp
            )
        }
    }
}

extension WeatherDescription: Entity {
    private var storableWeatherDetails: StorableWeatherDetails {
        let realmWeatherDetails = StorableWeatherDetails()
        realmWeatherDetails.icon = icon
        realmWeatherDetails.code = code
        realmWeatherDetails.weatherDescription = weatherDescription
        return realmWeatherDetails
    }
    
    func toStorable() -> StorableWeatherDetails {
        return storableWeatherDetails
    }
}

class StorableWeatherDetails: EmbeddedObject, Storable {
    
    @Persisted var icon: String?
    @Persisted var code: Int?
    @Persisted var weatherDescription: String?
    @Persisted var uuid: String = ""

    var model: WeatherDescription {
        get {
            return WeatherDescription(icon: icon,
                                      code: code,
                                      weatherDescription: weatherDescription)
        }
    }
}


public protocol Entity {
    associatedtype StoreType: Storable
    
    func toStorable() -> StoreType
}

public protocol Storable {
    associatedtype EntityObject: Entity
    
    var model: EntityObject { get }
    var uuid: String { get }
}
