//
//  BaseViewController.swift
//  WeatherApp
//
//  Created by Manish Tamta on 25/05/2022.
//

import UIKit

class BaseViewController: UIViewController {
    
    let scheduler: SchedulerContext = SchedulerContextProvider.provide()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func showAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
