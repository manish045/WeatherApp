//
//  SettingsCollectionViewCell.swift
//  WeatherApp
//
//  Created by Manish Tamta on 24/05/2022.
//

import UIKit

class SettingsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkMarkImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var unitKey: UnitKey! {
        didSet {
            self.titleLabel.text = unitKey.title
        }
    }
    
    override var isSelected: Bool {
        didSet {
            self.checkMarkImage.isHidden = !isSelected
        }
    }

}

extension SettingsCollectionViewCell {
    
    static func settingsSectionLayout(heightDimension: NSCollectionLayoutDimension = .absolute(52)) ->  NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: heightDimension)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
}
