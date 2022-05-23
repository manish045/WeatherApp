//
//  UIView+NibRepresentable.swift
//  WeatherApp
//
//  Created by Manish Tamta on 23/05/2022.
//

import UIKit

protocol NibRepresentable {
    static var nib: UINib { get }
    static var identifier: String { get }
}

extension UIView: NibRepresentable {
    class var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }

    class var identifier: String {
        return String(describing: self)
    }
}

extension NibRepresentable where Self: UIView {
    static var viewFromNib: Self {
        return Bundle.main.loadNibNamed(
            Self.identifier,
            owner: nil, options: nil)?.first as! Self
    }
}

extension UIViewController: NibRepresentable {
    class var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }

    class var identifier: String {
        return String(describing: self)
    }
}

protocol StoryboardInstantiatable {}

extension UIViewController: StoryboardInstantiatable {}

extension StoryboardInstantiatable where Self: NibRepresentable {
    static func instantiateFromStoryboard() -> Self {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: Self.identifier)
        return vc as! Self
    }
}

protocol ViewControllerRepresentable: AnyObject {
    var view: UIView! { get }
}
extension UIViewController: ViewControllerRepresentable {}
