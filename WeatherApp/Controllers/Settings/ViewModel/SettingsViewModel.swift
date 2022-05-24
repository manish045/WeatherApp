//
//  SettingsViewModel.swift
//  WeatherApp
//
//  Created by Manish Tamta on 23/05/2022.
//

import Foundation

protocol SettingsViewModelInput {
    func dismissViewController()
}

protocol SettingsViewModelOutput {}

protocol SettingsViewModel: SettingsViewModelInput, SettingsViewModelOutput {}

final class DefaultSettingsViewModel: SettingsViewModel {
    
    let coordinator: SettingsViewCoordinatorInput
    
    init(coordinator: SettingsViewCoordinatorInput) {
        self.coordinator = coordinator
    }
    
    func dismissViewController() {
        self.coordinator.dismissViewController()
    }
    
}
