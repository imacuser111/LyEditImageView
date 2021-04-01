//
//  AlertView.swift
//  LyEditImageView
//
//  Created by Cheng-Hong on 2021/3/30.
//  Copyright © 2021 Li,Yan(MMS). All rights reserved.
//

import UIKit

class AlertView: UIView {
    
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    var status = false
    
    override func layoutSubviews() {
        self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(removeAlert)))
        setCollectionView()
    }
    
    @objc func removeAlert() {
        removeFromSuperview()
        status.toggle()
    }
}

extension AlertView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func setCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(AlertCollectionViewCell.loadFromNib(), forCellWithReuseIdentifier: "AlertCollectionViewCell")
        viewHeight.constant = CGFloat(60 * tableViewTitle.allCases.count)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tableViewTitle.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlertCollectionViewCell", for: indexPath) as! AlertCollectionViewCell
        let index = tableViewTitle(rawValue: indexPath.row)
        cell.titleTableViewCellModel = TitleTableViewCellModel(labelText: index?.title.0 ?? "", image: index?.title.1 ?? "")
        return cell
    }
}
