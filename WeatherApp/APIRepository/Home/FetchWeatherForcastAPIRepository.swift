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
                      completion: @escaping (APIResult<WeatherForecastList, APIError>) -> Void)
}

struct FetchWeatherForcastAPIRepository: WeatherAPIRepository {
    
    func fetchDetails(endPoint: EndPoints,
                      parameters: [String : Any],
                      completion: @escaping (APIResult<WeatherForecastList, APIError>) -> Void) {
        APIWeatherForcastService.shared.performRequest(endPoint: endPoint, parameters: parameters) { (result: APIResult<WeatherDataModel, APIError>) in
            switch result {
            case .success(let model):
                let weatherDataArray = model.data ?? []
                saveWeatherForecastData(weatherForcastList: weatherDataArray)
                completion(.success(weatherDataArray))
            case .error(let apiError):
               
                DatabaseManager.shared.fetchWeatherForecastList { result in
                    switch result {
                    case .success(let weatherList):
                        completion(.success(weatherList))
                    case .error(_):
                        completion(.error(apiError))
                    }
                }
            }
        }
    }
    
    func saveWeatherForecastData(weatherForcastList: WeatherForecastList) {
        DatabaseManager.shared.removeAllWeatherForecastData()
        DatabaseManager.shared.saveWeatherList(weatherForecastList: weatherForcastList)
    }
}
