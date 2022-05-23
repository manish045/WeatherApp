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

class WeatherForcastCoordinator: Coordinator, WeatherForcastCoordinatorInput {
    
    var rootController: UIViewController?
    
    func makeModule() -> UIViewController {
        let vc = createViewController()
        rootController = vc
        return vc
    }
    
    private func createViewController() -> WeatherForcastViewController {
        // initializing view controller
        let view = WeatherForcastViewController.instantiateFromStoryboard()
        let viewModel = DefaultWeatherForcastViewModel(coordinator: self)
        view.viewModel = viewModel
        return view
    }
    
    func pushToDetail(model: WeatherForecastModel, subInfoModel: WeatherDetailInfoModel) {
        let vc = MCharacterDetailCoordinator().makeModule(model: model,
                                                          subInfoModel: subInfoModel)
        rootController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func openSettings() {
        
    }
}
