//
//  SectionLayoutProvider.swift
//  WeatherApp
//
//  Created by Manish Tamta on 23/05/2022.
//

import UIKit

public protocol SectionLayoutProvider {
    func layout(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection?    
}
