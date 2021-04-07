//
//  menuItem.swift
//  LyEditImageView
//
//  Created by Cheng-Hong on 2021/4/7.
//  Copyright © 2021 Li,Yan(MMS). All rights reserved.
//

import UIKit
protocol MenuItemDelegate: class {
    func leftButtonTapped()
}

class MenuBarButtonItem: UIBarButtonItem {
    
    var menuBtn: UIButton = {
        let menuBtn = UIButton(type: .custom)
        menuBtn.frame = CGRect(x: 0.0, y: 0.0, width: 30, height: 30)
        menuBtn.setImage(UIImage(named:"rotate"), for: .normal)
        return menuBtn
    }()
    
    weak var delegate: MenuItemDelegate?
    
    override init() {
        super.init()
        customView = menuBtn
        customView?.widthAnchor.constraint(equalToConstant: 30).isActive = true
        customView?.heightAnchor.constraint(equalToConstant: 30).isActive = true
        menuBtn.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func leftButtonTapped() {
        delegate?.leftButtonTapped()
    }

}
