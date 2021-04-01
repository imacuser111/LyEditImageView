//
//  AlertCollectionViewCell.swift
//  LyEditImageView
//
//  Created by Cheng-Hong on 2021/3/30.
//  Copyright © 2021 Li,Yan(MMS). All rights reserved.
//

import UIKit

class AlertCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var collectionViewImage: UIImageView!
    @IBOutlet weak var label: UILabel!
    var titleTableViewCellModel: TitleTableViewCellModel? {
        didSet {
            collectionViewImage.image = UIImage(named: titleTableViewCellModel?.image ?? "")
            label.text = titleTableViewCellModel?.labelText
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

}
