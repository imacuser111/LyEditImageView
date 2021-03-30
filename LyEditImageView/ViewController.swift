//
//  ViewController.swift
//  LyEditImageView
//
//  Created by Li,Yan(MMS) on 2017/6/14.
//  Copyright © 2017年 Li,Yan(MMS). All rights reserved.
//

import UIKit

protocol ViewControllerDelegate: class {
    func getCropImage(image: UIImage)
}

class ViewController: UIViewController {
    let imagePickerController = UIImagePickerController()
    var type = 0
    var editView: LyEditImageView?
    weak var delegate: ViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        imagePickerController.delegate = self
        imagePickerController.modalPresentationStyle = .fullScreen
        openPhotoLibrary()
        editView = LyEditImageView(frame: view.frame)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension ViewController: LyEditImageViewDelegate {
    func buttonAction(image: UIImage) {
        delegate?.getCropImage(image: image)
//        editView?.removeFromSuperview()
        navigationController?.popViewController(animated: true)
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // info 用來取得不同類型的圖片，此 Demo 的型態為 originaImage，其它型態有影片、修改過的圖片等等
        if let image = info[.originalImage] as? UIImage {
            editView?.delegate = self
            let image = image
            editView?.type = self.type
            editView?.initWithImage(image: image)
            
            self.view.addSubview(editView ?? UIView())
            self.view.backgroundColor = UIColor.clear
        }
        
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
        navigationController?.popViewController(animated: false)
    }
    
    /// 開啟圖庫
    func openPhotoLibrary() {
        imagePickerController.sourceType = .photoLibrary
        self.present(imagePickerController, animated: true)
    }
}
