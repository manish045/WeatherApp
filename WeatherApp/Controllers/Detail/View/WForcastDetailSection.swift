//
//  MCharacterDetailSection.swift
//  WeatherApp
//
//  Created by Manish Tamta on 23/05/2022.
//

import UIKit

enum WForcastDetailSection: Int {
    case mainInfo = 0
    case coFactors
}

enum WForcastDetailItem: Hashable {
    case infoItem(WeatherDetailInfoModel)
    case infoChunksItem(WeatherInfo)
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
