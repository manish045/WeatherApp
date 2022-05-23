//
// UICollectionView+Extension.swift
//  WeatherApp
//
//  Created by Manish Tamta on 23/05/2022.
//

import UIKit
 
extension UICollectionView {
    func dequeueCell<T: UICollectionViewCell>(
        _ type: T.Type,
        indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(
            withReuseIdentifier: "\(type)",
            for: indexPath) as! T
    }
    
    func registerNibCell<T: UICollectionViewCell>(ofType cellType: T.Type) {
        let nib = UINib(nibName: "\(cellType)", bundle: nil)
        register(nib, forCellWithReuseIdentifier: "\(cellType)")
    }
    
    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(
        _ type: T.Type,
        kind: String,
        indexPath: IndexPath) -> T {
        return self.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: "\(type)",
            for: indexPath) as! T
    }

    func registerHeader<T: UICollectionReusableView>(ofType type: T.Type) {
        self.register(
            type,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "\(type)")
    }

    func registerFooter<T: UICollectionReusableView>(ofType type: T.Type) {
        self.register(
            type,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: "\(type)")
    }
}
