//
//  SideMenuManager.swift
//  LyEditImageView
//
//  Created by Chang-Hong on 2021/3/26.
//  Copyright © 2021 Li,Yan(MMS). All rights reserved.
//

import UIKit

class SideMenuManager: NSObject {
    
    private var width: CGFloat = (UIApplication.shared.keyWindow?.frame.width)! * 0.65
    private var menuView: UIView!
    private var tagetView: UIView!
    lazy var blackView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(white: 0, alpha: 0.5)
        v.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
        return v
    }()
    
    init(menuView: UIView, targetView: UIView) {
        super.init()
        self.menuView = menuView
        self.width = menuView.frame.width
        self.tagetView = targetView
        targetView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(menuGestureAction(_:))))
        
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(self.blackView)
            window.addSubview(menuView)
            menuView.frame = CGRect(x: -self.width, y: 0, width: self.width, height: window.frame.height)
            menuView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gestureAction(_:))))
            self.blackView.frame = window.frame
            self.blackView.alpha = 0
        }
    }
    
    func showSettings() {
        //show menu
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.blackView.alpha = 1
            self.menuView.frame.origin = CGPoint(x: 0, y: 0)
        }, completion: nil)
    }
    
    @objc func handleDismiss() {
        UIView.animate(withDuration: 0.25
            , animations: {
                self.blackView.alpha = 0
                self.menuView.frame.origin = CGPoint(x: -self.width, y: 0)
        }) { (_) in
            
        }
    }
    
}

// 加入漢堡返關閉手勢
extension SideMenuManager {
    
    @objc func gestureAction(_ gesture: UIPanGestureRecognizer) {
        
        let gestureIsDraggingFromRightToLeft = (gesture.velocity(in: blackView).x < 0)
        var flag = false
        switch(gesture.state) {
        case .began:
            flag = true
        case .changed:
            if (((gesture.view!.center.x + gesture.translation(in: blackView).x) < blackView.center.x || gestureIsDraggingFromRightToLeft) && (gesture.view!.center.x <= blackView.center.x && gesture.velocity(in: blackView).x < 0 || gesture.view!.center.x < blackView.center.x && gesture.velocity(in: blackView).x > 0) && gesture.view!.center.x + gesture.translation(in: blackView).x < blackView.center.x) && flag {
                gesture.view!.center.x = gesture.view!.center.x + gesture.translation(in: blackView).x
                gesture.setTranslation(CGPoint(x: 0, y: 0), in: blackView)
            }
            var x = 0 + gesture.translation(in: blackView).x
            x = x < -width ? -width : x
            x = x > 0 ? 0 : x
            menuView.frame.origin = CGPoint(x: x, y: 0)
            blackView.alpha = 1 + (x / width)
        case .ended:
            if gesture.velocity(in: blackView).x < -50 || gesture.translation(in: blackView).x < -width * 0.5 {
                handleDismiss()
            } else {
                showSettings()
            }
        default:
            break
        }
    }
    
    @objc func menuGestureAction(_ gesture: UIPanGestureRecognizer) {
        let width = (UIApplication.shared.keyWindow?.frame.width)! * 0.65
        let gestureIsDraggingFromLeftToRight = (gesture.velocity(in: tagetView).x > 0)
        var flag = false
        switch(gesture.state) {
        case .began:
            flag = true
        case .changed:
            if (((gesture.view!.center.x + gesture.translation(in: tagetView).x) > tagetView.center.x || gestureIsDraggingFromLeftToRight) && (gesture.view!.center.x >= tagetView.center.x && gesture.velocity(in: tagetView).x > 0 || gesture.view!.center.x > tagetView.center.x && gesture.velocity(in: tagetView).x < 0) && gesture.view!.center.x + gesture.translation(in: tagetView).x > tagetView.center.x) && flag {
                gesture.view!.center.x = gesture.view!.center.x + gesture.translation(in: tagetView).x
                gesture.setTranslation(CGPoint(x: 0, y: 0), in: tagetView)
            }
            var x = -width + gesture.translation(in: tagetView).x
            x = x > 0 ? 0 : x
            x = x < -width ? -width : x
            self.menuView.frame.origin = CGPoint(x: x, y: 0)
            self.blackView.alpha = 1 + (x / width)
        case .ended:
            if gesture.velocity(in: tagetView).x > 50 || gesture.translation(in: tagetView).x > width * 0.5 {
                showSettings()
            } else {
                handleDismiss()
            }
        default:
            break
        }
    }
}

