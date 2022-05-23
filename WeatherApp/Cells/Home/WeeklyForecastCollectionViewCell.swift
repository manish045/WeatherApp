//
//  WeeklyForecastCollectionViewCell.swift
//  WeatherApp
//
//  Created by Manish Tamta on 23/05/2022.
//

import UIKit

class WeeklyForecastCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var tempDescriptionLabel: UILabel!
    @IBOutlet weak var tempIconImageView: UIImageView!
    
    override class func awakeFromNib() {
        
    }
    
    var model: WeatherForecastModel! {
        didSet {
            dateLabel.text = model.dateInString
            tempLabel.text = TemperatureUnitManager.shared.getCurrentTemp(temp: model.temp ?? 0)
            tempDescriptionLabel.text = model.weather?.weatherDescription ?? ""
            if let weather = model.weather, let icon = weather.icon {
                tempIconImageView.image = UIImage(named: icon)
            }
        }
    }
}

extension WeeklyForecastCollectionViewCell {
    
    static var heroCollectionSectionLayout:  NSCollectionLayoutSection {
        let heightDimension = NSCollectionLayoutDimension.estimated(111)

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets.bottom = 15

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: heightDimension)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets.leading = 15
        group.contentInsets.trailing = 15

        let section = NSCollectionLayoutSection(group: group)
        return section
    }
}
