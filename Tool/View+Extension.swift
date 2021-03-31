//
//  View+Extenstion.swift
//  LyEditImageView
//
//  Created by Chang-Hong on 2021/3/29.
//  Copyright © 2021 Li,Yan(MMS). All rights reserved.
//

import UIKit

extension UIView {
    class func initFromNib() -> Self {
        return initFromNib(self)
    }
    
    private class func initFromNib<T: UIView>(_ type: T.Type) -> T {
        let objects = Bundle.main.loadNibNamed(String(describing: self), owner: self, options: [:])
        return objects?.first as? T ?? T()
    }
    
    public class func loadFromNib() -> UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
}
