//
//  WForcastDetailViewModel.swift
//  WeatherApp
//
//  Created by Manish Tamta on 23/05/2022.
//

import Foundation
import Combine

protocol InputWForcastDetailViewModel {

}

protocol OutputWForcastDetailViewModel {

}

protocol WForcastDetailViewModel: InputWForcastDetailViewModel, OutputWForcastDetailViewModel {}

final class DefaultWForcastDetailViewModel: WForcastDetailViewModel {
    
    var weatherForecastModel: WeatherForecastModel
            
    init(weatherForecastModel: WeatherForecastModel) {
        self.weatherForecastModel = weatherForecastModel
    }
    
}
