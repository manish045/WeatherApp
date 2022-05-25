//
//  MCharacterDetailCoordinator.swift
//  WeatherApp
//
//  Created by Manish Tamta on 23/05/2022.
//

import UIKit

protocol MForcastDetailCoordinatorInput {
    
}

class MForcastDetailCoordinator: Coordinator, MForcastDetailCoordinatorInput {
    
    var rootController: UIViewController?
    
    init() {}
    
    func makeModule(model: WeatherForecastModel, subInfoModel: WeatherDetailInfoModel) -> UIViewController {
        let vc = createViewController(model: model,
                                      subInfoModel: subInfoModel)
        rootController = vc
        return vc
    }
    
    private func createViewController(model: WeatherForecastModel, subInfoModel: WeatherDetailInfoModel) -> WForcastDetailViewController {
        // initializing view controller
        let view = WForcastDetailViewController.instantiateFromStoryboard()
        let viewModel = DefaultWForcastDetailViewModel(weatherForecastModel: model,
                                                       subInfoModel: subInfoModel)
        view.viewModel = viewModel
        return view
    }
}
