//
//  HomeViewModel.swift
//  WeatherApp
//
//  Created by Manish Tamta on 23/05/2022.
//

import Foundation
import Combine
    
protocol WeatherForcastModelInput {

}

protocol WeatherForcastViewModelOutput {
}

protocol WeatherForcastViewModel: WeatherForcastModelInput, WeatherForcastViewModelOutput {}

final class DefaultWeatherForcastViewModel: WeatherForcastViewModel {
    
    var apiService: APIMarvelService
    var coordinator: WeatherForcastCoordinatorInput
    
    init(apiService: APIMarvelService = APIMarvelService.shared,
         coordinator: WeatherForcastCoordinatorInput) {
        self.apiService = apiService
        self.coordinator = coordinator
    }

}
