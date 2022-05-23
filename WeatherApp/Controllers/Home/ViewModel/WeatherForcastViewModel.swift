//
//  WeatherForcastViewModel.swift
//  WeatherApp
//
//  Created by Manish Tamta on 23/05/2022.
//

import Foundation
import Combine
import CoreLocation
    
protocol WeatherForcastModelInput {
    func fetchWeatherForcast()
}

protocol WeatherForcastViewModelOutput {
    
}

protocol WeatherForcastViewModel: WeatherForcastModelInput, WeatherForcastViewModelOutput {}

final class DefaultWeatherForcastViewModel: WeatherForcastViewModel {
    
    var apiService: APIWeatherForcastService
    var coordinator: WeatherForcastCoordinatorInput
    
    init(apiService: APIWeatherForcastService = APIWeatherForcastService.shared,
         coordinator: WeatherForcastCoordinatorInput) {
        self.apiService = apiService
        self.coordinator = coordinator
    }

    func fetchWeatherForcast() {
        self.fetchCurrentCoordinates { [weak self] lat, long in
            guard let self = self else {return}
            self.apiService.performRequest(endPoint: .dailyForecast, parameters: self.createParametersToFetchForcast(latitude: lat, longitude: long)) { [weak self] (result: APIResult<WeatherDataModel, APIError>) in
                switch result {
                case .success(let model):
                    print(model)
                case .error(let error):
                    guard let self = self else {return}
                    print(error)
                    break
                }
            }
        }
    }
    
    private func fetchCurrentCoordinates(completion: @escaping(Double, Double) -> Void) {
        LocationManager.shared.getLocation { (location: CLLocation?, error:NSError?) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let location = location else {
                return
            }
    
            print("Latitude: \(location.coordinate.latitude) Longitude: \(location.coordinate.longitude)")
            completion(location.coordinate.latitude, (location.coordinate.longitude))
        }
    }
    
    private func createParametersToFetchForcast(latitude: Double, longitude: Double) -> [String : Any] {
        let daysNumber = 16
        let unit = TemperatureUnitManager.shared.generalUnit.rawValue
        
        return [
            "days": daysNumber,
            "lat": latitude,
            "lon": longitude,
            "units": unit,
        ]
    }
}
