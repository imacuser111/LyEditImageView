//
//  RightBarButtonItem.swift
//  LyEditImageView
//
//  Created by Cheng-Hong on 2021/4/7.
//  Copyright © 2021 Li,Yan(MMS). All rights reserved.
//

import UIKit
protocol RightBarButtonItemDelegate: class {
    func rightButtonTapped()
}

class RightBarButtonItem: UIBarButtonItem {

    var alertBtn: UIButton = {
        let alertBtn = UIButton(type: .custom)
        alertBtn.frame = CGRect(x: 0.0, y: 0.0, width: 30, height: 30)
        alertBtn.setImage(UIImage(named:"rotate"), for: .normal)
        return alertBtn
    }()
    
    weak var delegate: RightBarButtonItemDelegate?
    
    override init() {
        super.init()
        customView = alertBtn
        customView?.widthAnchor.constraint(equalToConstant: 30).isActive = true
        customView?.heightAnchor.constraint(equalToConstant: 30).isActive = true
        alertBtn.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func rightButtonTapped() {
        delegate?.rightButtonTapped()
    }
}
