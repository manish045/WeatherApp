//
//  HomeViewCoordinator.swift
//  WeatherApp
//
//  Created by Manish Tamta on 23/05/2022.
//

import UIKit

protocol WeatherForcastCoordinatorInput {
    func pushToDetail(model: WeatherForecastModel, subInfoModel: WeatherDetailInfoModel)
    func openSettings()
}

/// Coordinator :- Organizing flow logic between view controllers
class WeatherForcastCoordinator: Coordinator, WeatherForcastCoordinatorInput {
    
    var rootController: UIViewController?
    
    //Create View Controller instance with all possible initialization for viewModel and controller
    func makeModule() -> UIViewController {
        let vc = createViewController()
        rootController = vc
        return vc
    }
    
    //Pass the navigationController to the initial controller
    private func createViewController() -> WeatherForcastViewController {
        // initializing view controller
        let view = WeatherForcastViewController.instantiateFromStoryboard()
        let viewModel = DefaultWeatherForcastViewModel(coordinator: self)
        view.viewModel = viewModel
        return view
    }
    
    func pushToDetail(model: WeatherForecastModel, subInfoModel: WeatherDetailInfoModel) {
        let vc = MForcastDetailCoordinator().makeModule(model: model,
                                                          subInfoModel: subInfoModel)
        rootController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func openSettings() {
        let vc = SettingsViewCoordinator().makeModule()
        rootController?.navigationController?.pushViewController(vc, animated: true)
    }
}
