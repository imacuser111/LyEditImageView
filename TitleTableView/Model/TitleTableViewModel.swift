//
//  TitleTableViewModel.swift
//  LyEditImageView
//
//  Created by Cheng-Hong on 2021/3/31.
//  Copyright © 2021 Li,Yan(MMS). All rights reserved.
//

import Foundation

enum tableViewTitle: Int, CaseIterable {
    case all = 0, creat, outPut, into, upload, download, shopOutPut, shopInto, delete, use
    var title: (String, String) {
        switch self {
        case .all:
            return ("全部", "cancel.png")
        case .creat:
            return ("創建", "cancel.png")
        case .outPut:
            return ("移出", "cancel.png")
        case .into:
            return ("移入", "cancel.png")
        case .upload:
            return ("上架", "cancel.png")
        case .download:
            return ("下架", "cancel.png")
        case .shopOutPut:
            return ("市集移出", "cancel.png")
        case .shopInto:
            return ("市集移入", "cancel.png")
        case .delete:
            return ("已丟棄", "cancel.png")
        case .use:
            return("使用", "cancel.png")
        }
    }
}

struct TitleTableViewCellModel {
    let labelText: String
    let image: String
}
