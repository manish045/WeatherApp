//
//  HomeViewCoordinator.swift
//  WeatherApp
//
//  Created by Manish Tamta on 23/05/2022.
//

import UIKit

protocol WeatherForcastCoordinatorInput {

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
}
