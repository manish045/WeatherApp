//
//  Coordinator.swift
//  WeatherApp
//
//  Created by Manish Tamta on 23/05/2022.
//

import UIKit

/** Basic interface for coordinator.
 It describes all the methods available outside the module (for coordinator owner) */
protocol Coordinator {

    //    /// Generic type of the data to compose initial screen
    //    associatedtype InputData

    /// Intial controller of the module
    var rootController: UIViewController? { get }
}

extension Coordinator {
    /// Module's entry point. Call this method to start the module
    ///
    /// - Parameters:
    ///   - data: with this data the initial screen is configured
    ///   - presentingController: the initial controller is shown from it
    func start(from presentingController: UIViewController) {

    }
}
