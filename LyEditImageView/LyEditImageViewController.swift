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

class LyEditImageViewController: UIViewController {
    let imagePickerController = UIImagePickerController()
    private let type: Int
    var editView: LyEditImageView?
    weak var delegate: ViewControllerDelegate?
    
    init(type: Int) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //關閉手勢返回功能
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        imagePickerController.delegate = self
        imagePickerController.modalPresentationStyle = .fullScreen
        openPhotoLibrary()
        editView = LyEditImageView(frame: view.frame, type: type)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension LyEditImageViewController: LyEditImageViewDelegate {
    func buttonAction(image: UIImage) {
        delegate?.getCropImage(image: image)
        navigationController?.popViewController(animated: true)
    }
}

extension LyEditImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // info 用來取得不同類型的圖片，此 Demo 的型態為 originaImage，其它型態有影片、修改過的圖片等等
        if let image = info[.originalImage] as? UIImage {
            editView?.delegate = self
            let image = image
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
