//
//  MCharacterDetailSection.swift
//  WeatherApp
//
//  Created by Manish Tamta on 23/05/2022.
//

import UIKit

enum WForcastDetailSection: Int {
    case mainInfo
    case coFactors
}

enum WForcastDetailItem: Hashable {
    case infoItem(WeatherForecastModel)
    case infoChunksItem(WeatherForecastModel)
}

extension WForcastDetailSection: Sectionable {
    func layout(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? {
        switch self {
        case .mainInfo:
            return WForcastDetailInfoMainCollectionViewCell.wForcastDetailInfoMainSectionLayout()
        case .coFactors:
            return WForcastDetailCoFactorCollectionViewCell.coFactorSectionLayout()
        }
    }
}
