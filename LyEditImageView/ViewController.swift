//
//  ViewController.swift
//  LyEditImageView
//
//  Created by Li,Yan(MMS) on 2017/6/14.
//  Copyright © 2017年 Li,Yan(MMS). All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var image = UIImage()
    var type = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y + 10, width: self.view.frame.width, height: self.view.frame.height)
        let editView = LyEditImageView(frame: frame)
        let image = self.image
        editView.type = self.type
        editView.initWithImage(image: image)
        
        self.view.addSubview(editView)
        self.view.backgroundColor = UIColor.clear
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

}
