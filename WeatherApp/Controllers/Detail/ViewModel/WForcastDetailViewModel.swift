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
    var infoModel: [WeatherInfo] {get}
    var subInfoModel: WeatherDetailInfoModel {get}
}

protocol WForcastDetailViewModel: InputWForcastDetailViewModel, OutputWForcastDetailViewModel {}

final class DefaultWForcastDetailViewModel: WForcastDetailViewModel {
    
    private var weatherForecastModel: WeatherForecastModel
    var subInfoModel: WeatherDetailInfoModel
    var infoModel: [WeatherInfo]
            
    init(weatherForecastModel: WeatherForecastModel,
         subInfoModel: WeatherDetailInfoModel) {
        
        self.weatherForecastModel = weatherForecastModel
        self.subInfoModel = subInfoModel
        self.infoModel = weatherForecastModel.getWeatherInfo()
    }
    
}
