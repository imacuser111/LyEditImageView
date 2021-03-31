//
//  Image+Extenstion.swift
//  LyEditImageView
//
//  Created by Chang-Hong on 2021/3/29.
//  Copyright © 2021 Li,Yan(MMS). All rights reserved.
//

import UIKit

class CropImage: NSObject {
    static let shared = CropImage()
    
    func cropImage(image: UIImage, rect: CGRect) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(rect.size, false, image.scale)
        image.draw(at: CGPoint(x: -rect.origin.x, y: -rect.origin.y))
        guard let cropped_image = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()
        return cropped_image
    }
}

extension UIImage {
    func resize(targetSize: CGSize) -> UIImage {
        if #available(iOS 10.0, *) {
            return UIGraphicsImageRenderer(size:targetSize).image { _ in
                self.draw(in: CGRect(origin: .zero, size: targetSize))
            }
        } else {
            return scaleImageToSize(newSize: targetSize)
        }
    }
    
    func scaleImageToSize(newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(newSize)
        self.draw(in: CGRect(origin: .zero, size: newSize))
        guard let scaledImage = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
}
