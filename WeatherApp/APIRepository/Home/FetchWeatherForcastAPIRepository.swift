//
//  FetchWeatherForcastAPIRepository.swift
//  WeatherApp
//
//  Created by Manish Tamta on 24/05/2022.
//

import Foundation

protocol WeatherAPIRepository {
    func fetchDetails(endPoint: EndPoints,
                      parameters: [String : Any],
                      completion: @escaping (APIResult<WeatherDataModel, APIError>) -> Void)
}

struct FetchWeatherForcastAPIRepository: WeatherAPIRepository {
    
    func fetchDetails(endPoint: EndPoints,
                      parameters: [String : Any],
                      completion: @escaping (APIResult<WeatherDataModel, APIError>) -> Void) {
        APIWeatherForcastService.shared.performRequest(endPoint: endPoint, parameters: parameters) { (result: APIResult<WeatherDataModel, APIError>) in
            switch result {
            case .success(let model):
                saveWeatherForecastData(weatherModel: model)
                completion(.success(model))
            case .error(let apiError):
               
                DatabaseManager.shared.fetchWeatherForecastList { result in
                    switch result {
                    case .success(let weatherList):
                        let model = createOfflineWeatherDataModel(weatherList: weatherList)
                        completion(.success(model))
                    case .error(_):
                        completion(.error(apiError))
                    }
                }
            }
        }
    }
    
    func saveWeatherForecastData(weatherModel: WeatherDataModel) {
        if let weatherForcastList = weatherModel.data, weatherForcastList.count > 0 {
            UserDefaultsManager.shared.saveObject(weatherModel.cityName, key: .cityName)
            UserDefaultsManager.shared.saveObject(weatherModel.lat, key: .lat)
            UserDefaultsManager.shared.saveObject(weatherModel.lon, key: .long)

            DatabaseManager.shared.removeAllWeatherForecastData()
            DatabaseManager.shared.saveWeatherList(weatherForecastList: weatherForcastList)
        }
    }
    
    func createOfflineWeatherDataModel(weatherList: WeatherForecastList) -> WeatherDataModel {
        let cityName = UserDefaultsManager.shared.loadObject(forKey: .cityName) as? String
        let lat = UserDefaultsManager.shared.loadObject(forKey: .lat) as? Double
        let long = UserDefaultsManager.shared.loadObject(forKey: .long) as? Double
        
        return WeatherDataModel(data: weatherList,
                                cityName: cityName,
                                lon: long,
                                lat: lat)
    }
}
