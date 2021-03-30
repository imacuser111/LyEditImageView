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
        var scaledImageRect = CGRect.zero
        
        let aspectWidth = newSize.width/size.width
        let aspectheight = newSize.height/size.height
        
        let aspectRatio = max(aspectWidth, aspectheight)
        
        scaledImageRect.size.width = size.width * aspectRatio;
        scaledImageRect.size.height = size.height * aspectRatio;
        scaledImageRect.origin.x = (newSize.width - scaledImageRect.size.width) / 2.0
        scaledImageRect.origin.y = (newSize.height - scaledImageRect.size.height) / 2.0
        
        UIGraphicsBeginImageContext(newSize)
        draw(in: scaledImageRect)
        guard let scaledImage = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
}
