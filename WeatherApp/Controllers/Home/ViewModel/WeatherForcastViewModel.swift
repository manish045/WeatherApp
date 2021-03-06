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
    func addChangeInTempObserver()
    func pushToDetailScreen(model: WeatherForecastModel)
    func openSettings()
    func refreshCollectionViewData()
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
    
    var dispose = Set<AnyCancellable>()
    
    var apiService: WeatherAPIRepository
    private var coordinator: WeatherForcastCoordinatorInput
    private var weatherDataModel: WeatherDataModel?
    
    init(apiService: WeatherAPIRepository = FetchWeatherForcastAPIRepository(),
         coordinator: WeatherForcastCoordinatorInput) {
        self.apiService = apiService
        self.coordinator = coordinator
    }
    
    func refreshCollectionViewData() {
        fetchWeatherForcast()
    }

    private func fetchWeatherForcast() {
        self.fetchCurrentCoordinates { [weak self] lat, long in
            guard let self = self else {return}
            self.apiService.fetchDetails(endPoint: .dailyForecast, parameters: self.createParametersToFetchForcast(latitude: lat, longitude: long)) { [weak self] (result: APIResult<WeatherDataModel, APIError>) in
                switch result {
                case .success(let model):
                    guard let self = self else {return}
                    self.weatherDataModel = model
                    let data = model.data ?? []
                    self.loadDataSource.send(data)
                    LocalNotificationManager.shared.scheduleNotifications(weatherList: data)
                case .error(let error):
                    guard let self = self else {return}
                    self.didGetError.send(error)
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
            completion(location.coordinate.latitude, (location.coordinate.longitude))
        }
    }
    
     func createParametersToFetchForcast(latitude: Double, longitude: Double) -> [String : Any] {
        let daysNumber = 16
        let unit = TemperatureUnitManager.shared.currentUnit.rawValue

        return [
            "days": daysNumber,
            "lat": latitude,
            "lon": longitude,
            "units": unit,
        ]
    }
    
    func pushToDetailScreen(model: WeatherForecastModel) {
        var model = model
        guard let weatherDataModel = weatherDataModel else {return}
        let subInfoModel = WeatherDetailInfoModel(dateTime: model.dateInString,
                                                            cityName: weatherDataModel.cityName,
                                                            temp: model.temp,
                                                            lowTemp: model.lowTemp,
                                                            highTemp: model.highTemp,
                                                            weather: model.weather)
        self.coordinator.pushToDetail(model: model, subInfoModel: subInfoModel)
    }
    
    func addChangeInTempObserver() {
        TemperatureUnitManager.shared.changeInTempUnit
            .sink { unitKey in
                self.fetchWeatherForcast()
            }
            .store(in: &dispose)
    }
    
    func openSettings() {
        self.coordinator.openSettings()
    }
}
