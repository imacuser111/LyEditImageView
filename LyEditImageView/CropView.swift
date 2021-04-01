//
//  CropView.swift
//  LyEditImageView
//
//  Created by Chang-Hong on 2021/3/23.
//  Copyright © 2021 Li,Yan(MMS). All rights reserved.
//

import UIKit

class CropView: UIView {
    
    let LINE_WIDTH:CGFloat = 2

    var leftUpCornerPoint:UIView!
    var leftDownCornerPoint:UIView!
    var rightUpCornerPoint:UIView!
    var rightDownCornerPoint:UIView!
    
    var leftLine:UIView!
    var upLine:UIView!
    var rightLine:UIView!
    var downLine:UIView!
    
    var hittedViewTag: Int?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true;
        self.backgroundColor = UIColor.clear
        self.clipsToBounds = false;
        self.frame = frame;
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initCropViewSubViews() {
        leftLine = UIView();
        leftLine.frame = CGRect(x: 0, y: 0, width: LINE_WIDTH, height: self.frame.size.height);
        leftLine.backgroundColor = UIColor.white;
        self.addSubview(leftLine);
        leftLine.tag = LyEditImageViewTag.LEFT_LINE_TAG.rawValue
        
        upLine = UIView();
        upLine.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: LINE_WIDTH);
        upLine.backgroundColor = UIColor.white;
        self.addSubview(upLine);
        upLine.tag = LyEditImageViewTag.UP_LINE_TAG.rawValue
        
        rightLine = UIView();
        rightLine.frame = CGRect(x: self.frame.size.width - LINE_WIDTH, y: 0, width: LINE_WIDTH, height: self.frame.size.height);
        rightLine.backgroundColor = UIColor.white;
        self.addSubview(rightLine);
        rightLine.tag = LyEditImageViewTag.RIGHT_LINE_TAG.rawValue
        
        downLine = UIView();
        downLine.frame = CGRect(x:0, y: self.frame.size.height - LINE_WIDTH, width: self.frame.size.width, height: LINE_WIDTH);
        downLine.backgroundColor = UIColor.white;
        self.addSubview(downLine);
        downLine.tag = LyEditImageViewTag.DOWN_LINE_TAG.rawValue
        
        leftUpCornerPoint = UIView()
        leftUpCornerPoint.frame = CGRect(x: -5, y: -5, width: 10, height: 10)
        leftUpCornerPoint.backgroundColor = UIColor.white
        self.addSubview(self.leftUpCornerPoint)
        leftUpCornerPoint.tag = LyEditImageViewTag.LEFT_UP_TAG.rawValue
        
        leftDownCornerPoint = UIView()
        leftDownCornerPoint.frame = CGRect(x: -5, y: self.frame.size.height - 5, width: 10, height: 10)
        leftDownCornerPoint.backgroundColor = UIColor.white
        self.addSubview(self.leftDownCornerPoint)
        leftDownCornerPoint.tag = LyEditImageViewTag.LEFT_DOWN_TAG.rawValue
        
        rightUpCornerPoint = UIView()
        rightUpCornerPoint.frame = CGRect(x: self.frame.size.width - 5, y: -5, width: 10, height: 10)
        rightUpCornerPoint.backgroundColor = UIColor.white
        self.addSubview(self.rightUpCornerPoint)
        rightUpCornerPoint.tag = LyEditImageViewTag.RIGHT_UP_TAG.rawValue
        
        rightDownCornerPoint = UIView()
        rightDownCornerPoint.frame = CGRect(x: self.frame.size.width - 5, y: self.frame.size.height - 5, width: 10, height: 10)
        rightDownCornerPoint.backgroundColor = UIColor.white
        self.addSubview(self.rightDownCornerPoint)
        rightDownCornerPoint.tag = LyEditImageViewTag.RIGHT_DOWN_TAG.rawValue
    }
    
    // change subview's frame after cropview's constraints updated
    // hightlight the view been selected
    func updateSubView() {
        leftLine.frame = CGRect(x: 0, y: 0, width: LINE_WIDTH, height: self.frame.size.height)
        upLine.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: LINE_WIDTH)
        rightLine.frame = CGRect(x: self.frame.size.width - LINE_WIDTH, y: 0, width: LINE_WIDTH, height: self.frame.size.height)
        downLine.frame = CGRect(x:0, y: self.frame.size.height - LINE_WIDTH, width: self.frame.size.width, height: LINE_WIDTH)
        
        leftUpCornerPoint.frame = CGRect(x: -5, y: -5, width: 10, height: 10)
        leftDownCornerPoint.frame = CGRect(x: -5, y: self.frame.size.height - 5, width: 10, height: 10)
        rightUpCornerPoint.frame = CGRect(x: self.frame.size.width - 5, y: -5, width: 10, height: 10)
        rightDownCornerPoint.frame = CGRect(x: self.frame.size.width - 5, y: self.frame.size.height - 5, width: 10, height: 10)
    }
    
    // override point inside to enlarge subview's touch zone
    // and add tag to subviews
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        var pointInside = false
        
        if self.frame.contains(convert(point, to: self.superview)) {
            pointInside = true
            hittedViewTag = self.tag
        } else {
            for subview in subviews as [UIView] {
                if !subview.isHidden && subview.alpha > 0 && subview.isUserInteractionEnabled {
                    var extendFrame: CGRect
                    extendFrame = CGRect(x: subview.frame.origin.x - 20, y: subview.frame.origin.y - 20, width: subview.frame.size.width + 40, height: subview.frame.size.height + 40)
                    if extendFrame.contains(point) {
                        hittedViewTag = subview.tag
                        pointInside = true
                    }
                }
            }
        }
        return pointInside
    }
    
    func getCropViewTag() -> Int {
       if let tag = hittedViewTag {
            return tag
        }
        return 0;
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        updateSubView()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        resetHightLightView()
    }
    
    func resetHightLightView() {
        leftLine.frame = CGRect(x: 0, y: 0, width: LINE_WIDTH, height: self.frame.size.height);
        upLine.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: LINE_WIDTH);
        rightLine.frame = CGRect(x: self.frame.size.width - LINE_WIDTH, y: 0, width: LINE_WIDTH, height: self.frame.size.height);
        downLine.frame = CGRect(x:0, y: self.frame.size.height - LINE_WIDTH, width: self.frame.size.width, height: LINE_WIDTH);
    }
}
