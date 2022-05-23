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
    var loadDataSource: PassthroughSubject<WeatherForecastList, Never> { get}
    var didGetError: PassthroughSubject<APIError, Never> {get}
}

protocol WeatherForcastViewModel: WeatherForcastModelInput, WeatherForcastViewModelOutput {}

final class DefaultWeatherForcastViewModel: WeatherForcastViewModel {

    //load data from server
    var loadDataSource = PassthroughSubject<WeatherForecastList, Never>()
   
    // notifies for any error
    var didGetError = PassthroughSubject<APIError, Never>()
    
    
    private var apiService: APIWeatherForcastService
    private var coordinator: WeatherForcastCoordinatorInput
    
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
                    guard let self = self else {return}
                    let weatherDataArray = model.data
                    self.loadDataSource.send(weatherDataArray)
                case .error(let error):
                    guard let self = self else {return}
                    self.didGetError.send(error)
                    break
                }
            }
        }
    }
    
    private func fetchCurrentCoordinates(completion: @escaping(Double, Double) -> Void) {
        LocationManager.shared.getLocation { [weak self] (location: CLLocation?, error:NSError?) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let location = location else {
                return
            }    
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
