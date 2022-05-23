//
//  HomeViewModel.swift
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
    
    var apiService: APIWeatherService
    var coordinator: HomeViewCoordinatorInput
        
    init(apiService: APIWeatherService = APIWeatherService.shared,
         coordinator: HomeViewCoordinatorInput) {
        self.apiService = apiService
        self.coordinator = coordinator
    }
    
    func fetchWeatherForcast() {
        self.fetchCurrentCoordinates { lat, long in
            
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

}
