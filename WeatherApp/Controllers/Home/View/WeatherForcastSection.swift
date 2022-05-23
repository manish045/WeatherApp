//
//  WeatherForcastSection.swift
//  WeatherApp
//
//  Created by Manish Tamta on 23/05/2022.
//

import UIKit

enum WeatherForcastSection: Int {
    case characters = 0
    case loader
}

enum TemperatureItem: Hashable {
    case resultItem(WeatherForecastModel)
    case loading(LoadingItem)
}

extension WeatherForcastSection: Sectionable {
    func layout(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? {
        switch self {
        case .characters:
            // Section
            let layoutSection = WeeklyForecastCollectionViewCell.heroCollectionSectionLayout
            layoutSection.contentInsets.top = 15
            return layoutSection
        case .loader:
            return LoadingCollectionCell.loadingSectionLayout
        }
    }
}
