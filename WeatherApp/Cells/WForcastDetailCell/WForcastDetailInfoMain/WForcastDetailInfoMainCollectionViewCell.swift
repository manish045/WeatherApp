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
