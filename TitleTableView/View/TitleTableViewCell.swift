//
//  TitleTableViewCell.swift
//  LyEditImageView
//
//  Created by Chang-Hong on 2021/3/24.
//  Copyright © 2021 Li,Yan(MMS). All rights reserved.
//

import UIKit

class TitleTableViewCell: UITableViewCell {
    @IBOutlet weak var tableViewImage: UIImageView!
    @IBOutlet weak var label: UILabel!
    var titleTableViewCellModel: TitleTableViewCellModel? {
        didSet {
            tableViewImage.image = UIImage(named: titleTableViewCellModel?.image ?? "")
            label.text = titleTableViewCellModel?.labelText
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
