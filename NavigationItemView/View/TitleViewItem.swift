//
//  TitleViewItem.swift
//  LyEditImageView
//
//  Created by Cheng-Hong on 2021/4/7.
//  Copyright © 2021 Li,Yan(MMS). All rights reserved.
//

import UIKit
protocol TitleViewItemDelegate: class {
    func buttonTap()
}

class TitleViewItem: UIView {
    weak var delegate: TitleViewItemDelegate?
    
    override func layoutSubviews() {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        button.center.x = center.x
        button.setTitle("Button", for: .normal)
        button.backgroundColor = .lightGray
        button.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
        
        addSubview(button)
    }
    
    @objc func buttonTap() {
        delegate?.buttonTap()
    }
    
}
