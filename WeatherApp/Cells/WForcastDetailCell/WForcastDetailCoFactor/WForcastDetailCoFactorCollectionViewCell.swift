//
//  WForcastDetailCoFactorCollectionViewCell.swift
//  MarvelComics
//
//  Created by Manish Tamta on 21/05/2022.
//

import UIKit

class WForcastDetailCoFactorCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var valueLbl: UILabel!
    @IBOutlet weak var iconImgView: UIImageView!
    @IBOutlet weak var bagView: UIView!
    
    //MARK: Render data
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

extension WForcastDetailCoFactorCollectionViewCell {
    
    static func coFactorSectionLayout() ->  NSCollectionLayoutSection {

        let itemSize = NSCollectionLayoutSize(widthDimension:  .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 8, bottom: 0, trailing: 8)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/2),
                                               heightDimension: .absolute(125))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior  = .continuousGroupLeadingBoundary
        
        return section
    }
}
