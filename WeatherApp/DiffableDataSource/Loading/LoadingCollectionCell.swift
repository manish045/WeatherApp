//
//  LoadingCollectionCell.swift
//  WeatherApp
//
//  Created by Manish Tamta on 23/05/2022.
//

import UIKit
import Combine

public class LoadingCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var retryButton: UIButton!
    
    @IBOutlet weak var loadingIndicatorView: UIActivityIndicatorView!
    
    private var data: LoadingItem? = nil
    
    var retryIntent: PassthroughSubject<LoadingItem, Never>?
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        if #available(iOS 14.0, *) {
            retryButton.addAction(UIAction(handler: { [unowned self] _ in
                
                guard let item = data, item.state == .failed else {
                    return
                }
                
                self.retryTapped(for: item)
                
            }), for: .touchUpInside)
        } else {
            // Fallback on earlier versions
        }
    }
    
    func configure(data: LoadingItem) {
        self.data = data
        loadingIndicatorView.startAnimating()
        
        if data.state == .failed {
            retryButton.isHidden = false
            loadingIndicatorView.isHidden = true
        } else {
            retryButton.isHidden = true
            loadingIndicatorView.isHidden = false
        }
    }
    
    private func retryTapped(for item: LoadingItem) {
        
        guard let intent = retryIntent else {
            return
        }
        
        intent.send(item)
    }
    
}

extension LoadingCollectionCell {
    
    static var loadingSectionLayout: NSCollectionLayoutSection {
        let heightDimension = NSCollectionLayoutDimension.absolute(50)

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: heightDimension)
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets.bottom = 0

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: heightDimension)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        return section
    }
}
