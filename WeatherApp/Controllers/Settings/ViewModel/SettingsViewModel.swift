//
//  SettingsViewModel.swift
//  WeatherApp
//
//  Created by Manish Tamta on 23/05/2022.
//

import Foundation
import Combine

protocol SettingsViewModelInput {
    func dismissViewController()
    func saveTempUnit()
    func isSelectedUnit(unit: UnitKey) -> Bool
    func updateTempUnit(unitKey: UnitKey)
}

protocol SettingsViewModelOutput {
    var selectedUnit: CurrentValueSubject<UnitKey,Never> {get}
}

protocol SettingsViewModel: SettingsViewModelInput, SettingsViewModelOutput {}

final class DefaultSettingsViewModel: SettingsViewModel {
    
    let coordinator: SettingsViewCoordinatorInput

    var selectedUnit: CurrentValueSubject<UnitKey,Never>
    
    init(coordinator: SettingsViewCoordinatorInput) {
        self.coordinator = coordinator
        self.selectedUnit = CurrentValueSubject<UnitKey,Never>(TemperatureUnitManager.shared.currentUnit)
    }
    
    func dismissViewController() {
        self.coordinator.dismissViewController()
    }
    
    func updateTempUnit(unitKey: UnitKey) {
        selectedUnit.value = unitKey
    }
    
    func saveTempUnit() {
        let unit = selectedUnit.value
        TemperatureUnitManager.shared.updateUnit(unit: unit)
    }
    
    func isSelectedUnit(unit: UnitKey) -> Bool {
        return self.selectedUnit.value.rawValue == unit.rawValue
    }
}
