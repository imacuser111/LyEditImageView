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
            return ("全部", "icon_57")
        case .creat:
            return ("創建", "icon_54")
        case .outPut:
            return ("移出", "icon_55")
        case .into:
            return ("移入", "icon_56")
        case .upload:
            return ("上架", "icon_56")
        case .download:
            return ("下架", "icon_56")
        case .shopOutPut:
            return ("市集移出", "icon_56")
        case .shopInto:
            return ("市集移入", "icon_56")
        case .delete:
            return ("已丟棄", "icon_56")
        case .use:
            return("使用", "icon_56")
        }
    }
}
