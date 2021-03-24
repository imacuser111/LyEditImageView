//
//  TestViewController.swift
//  LyEditImageView
//
//  Created by Chang-Hong on 2021/3/23.
//  Copyright © 2021 Li,Yan(MMS). All rights reserved.
//

import UIKit

class TestViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate ,UIScrollViewDelegate{
    
    var imgview: UIImageView!
    var imagepicked:UIImage!
    
    @IBOutlet weak var scrollViewSquare: UIScrollView!
    
    let picker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        picker.delegate = self
        scrollViewSquare.delegate = self
        //ImageViewInit()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func ImageViewInit(){
        imgview = UIImageView()
        imgview.frame = CGRect(x: 0, y: 0, width: imagepicked.size.width, height: imagepicked.size.height)
        imgview.image = imagepicked
        imgview.contentMode = .scaleAspectFit
        imgview.backgroundColor = UIColor.lightGray
        scrollViewSquare.maximumZoomScale=4;
        scrollViewSquare.minimumZoomScale=0.02;
        scrollViewSquare.bounces=true;
        scrollViewSquare.bouncesZoom=true;
        scrollViewSquare.contentMode = .scaleAspectFit
        
        scrollViewSquare.contentSize = imagepicked.size
        scrollViewSquare.autoresizingMask = UIView.AutoresizingMask.flexibleWidth
        scrollViewSquare.addSubview(imgview)
        setZoomScale()
    }
    var minZoomScale:CGFloat!
    
    func setZoomScale(){
        let imageViewSize = imgview.bounds.size
        let scrollViewSize = scrollViewSquare.bounds.size
        let widthScale = scrollViewSize.width/imageViewSize.width
        let heightScale = scrollViewSize.height/imageViewSize.height
        minZoomScale = max(widthScale, heightScale)
        scrollViewSquare.minimumZoomScale = minZoomScale
        scrollViewSquare.zoomScale = minZoomScale
        print("height nd width scale \(widthScale) & \(heightScale) Min zoom scale \(String(describing: minZoomScale))")
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imgview
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagepicked = (info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as? UIImage)!
        print("Image (h,w) = (\(imagepicked.size.height) , \(imagepicked.size.width))")
        ImageViewInit()
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func button(_ sender: Any) {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
}
