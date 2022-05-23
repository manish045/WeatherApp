//
//  MCharacterDetailCoordinator.swift
//  WeatherApp
//
//  Created by Manish Tamta on 23/05/2022.
//

import UIKit

protocol MCharacterDetailCoordinatorInput {
    
}

class MCharacterDetailCoordinator: Coordinator {
    var rootController: UIViewController?
    
    init() {}
    
    func makeModule(model: WeatherForecastModel) -> UIViewController {
        let vc = createViewController(model: model)
        rootController = vc
        return vc
    }
    
    private func createViewController(model: WeatherForecastModel) -> WForcastDetailViewController {
        // initializing view controller
        let view = WForcastDetailViewController.instantiateFromStoryboard()
        let viewModel = DefaultWForcastDetailViewModel(weatherForecastModel: model)
        view.viewModel = viewModel
        return view
    }
}
