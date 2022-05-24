//
//  SettingsSection.swift
//  WeatherApp
//
//  Created by Manish Tamta on 24/05/2022.
//

import UIKit

enum SettingsSection: Int {
    case celcius = 0
    case fahrenheit
}

enum SettingsItem: Hashable {
    case tempUnit(UnitKey, Bool)
}

extension SettingsSection: Sectionable {
    func layout(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? {
        switch self {
        default:
            return SettingsCollectionViewCell.settingsSectionLayout()
        }
    }
}
