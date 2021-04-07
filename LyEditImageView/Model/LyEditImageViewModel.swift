//
//  LyEditImageViewModel.swift
//  LyEditImageView
//
//  Created by Cheng-Hong on 2021/3/31.
//  Copyright © 2021 Li,Yan(MMS). All rights reserved.
//

import UIKit

enum LyEditImageViewTag: Int {
    case LEFT_UP_TAG = 1101
    case LEFT_DOWN_TAG = 1102
    case RIGHT_UP_TAG = 1103
    case RIGHT_DOWN_TAG = 1104
    case LEFT_LINE_TAG = 1105
    case UP_LINE_TAG = 1106
    case RIGHT_LINE_TAG = 1107
    case DOWN_LINE_TAG = 1108
}

enum typeValue: Int, CaseIterable {
    case square = 0, rectangle
    var value: CGFloat {
        switch self {
        case .square:
            return 1
        case .rectangle:
            return 3.125
        }
    }
}

class LyEditImageViewModel {
}

