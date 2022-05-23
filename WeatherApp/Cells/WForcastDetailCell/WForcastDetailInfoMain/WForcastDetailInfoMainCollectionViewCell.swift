//
//  WForcastDetailInfoMainCollectionViewCell.swift
//  MarvelComics
//
//  Created by Manish Tamta on 22/05/2022.
//

import UIKit

class WForcastDetailInfoMainCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var lowTempLabel: UILabel!
    @IBOutlet weak var highTempLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var tempDescLabel: UILabel!
    @IBOutlet weak var tempIconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code\
    }

    var model: WeatherDetailInfoModel! {
        didSet {
            cityLabel?.text = model.cityName
            dateLabel?.text = model.dateTime
            tempLabel?.text = TemperatureUnitManager.shared.getCurrentTemp(temp: model.temp ?? 0)
            lowTempLabel?.text = "L: \(TemperatureUnitManager.shared.getCurrentTemp(temp: model.lowTemp ?? 0))"
            highTempLabel?.text = "H: \(TemperatureUnitManager.shared.getCurrentTemp(temp: model.highTemp ?? 0))"
            tempDescLabel?.text = model.weather?.weatherDescription
            if let icon = model.weather?.icon {
                tempIconImageView?.image = UIImage(named: icon)
            }else {
                tempIconImageView?.image = nil
            }
        }
    }
}

extension WForcastDetailInfoMainCollectionViewCell {
    
    static func wForcastDetailInfoMainSectionLayout() ->  NSCollectionLayoutSection {
        let heightDimension = NSCollectionLayoutDimension.absolute(275)

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets.bottom = 15

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: heightDimension)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)        
        return section
    }
}
