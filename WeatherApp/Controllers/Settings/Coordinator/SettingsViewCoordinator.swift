//
//  SettingsViewCoordinator.swift
//  WeatherApp
//
//  Created by Manish Tamta on 23/05/2022.
//

import UIKit


protocol SettingsViewCoordinatorInput {
    func dismissViewController()
}

class SettingsViewCoordinator: Coordinator, SettingsViewCoordinatorInput {
    var rootController: UIViewController?
    
    init() {}
    
    func makeModule() -> UIViewController
    {
        let vc = createViewController()
        rootController = vc
        return vc
    }
    
    private func createViewController() -> SettingsViewController {
        // initializing view controller
        let view = SettingsViewController.instantiateFromStoryboard()
        let viewModel = DefaultSettingsViewModel(coordinator: self)
        view.viewModel = viewModel
        return view
    }
    
    func dismissViewController() {
        self.rootController?.navigationController?.popViewController(animated: true)
    }
}
