//
//  UIImageView+ImageLoader.swift
//  WeatherApp
//
//  Created by Manish Tamta on 23/05/2022.
//

import UIKit
import SDWebImage

extension UIImageView {
    
    func downloadImage(from url: String?,
                       placeholderImage: UIImage?) {

        self.image = nil
        sd_cancelCurrentImageLoad()
        guard let originalUrlString = url else {
            image = placeholderImage
            return
        }

        if let transformedUrl = URL(string: originalUrlString) {

            if let image = SDImageCache.shared.imageFromDiskCache(forKey: transformedUrl.absoluteString) {
                self.image = image
                return
            }
            self.sd_setImage(with: transformedUrl, placeholderImage: placeholderImage, options: .avoidAutoSetImage)
            { [weak self] (image, error, cacheType, url) in
                if let error = error as NSError?, error.code != 2002 {
                    self?.tryFromOrignalURL(url: transformedUrl, placeholderImage: placeholderImage)
                } else {
                    self?.image = image
                }
            }
        }
    }

    func tryFromOrignalURL(url: URL, placeholderImage: UIImage?) {
        self.sd_setImage(with: url, placeholderImage: placeholderImage, options: .avoidAutoSetImage)
        { [weak self] (image, error, cacheType, url) in
            if error != nil {
                self?.image = placeholderImage
            } else {
                self?.image = image
            }
        }
    }

    func cancelImageDownloading() {
        sd_cancelCurrentImageLoad()
    }
}
