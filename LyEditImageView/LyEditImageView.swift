//
//  ViewController.swift
//  LyEditImageView
//
//  Created by Li,Yan(MMS) on 2017/6/10.
//  Copyright © 2017年 Li,Yan(MMS). All rights reserved.

import UIKit
import AVFoundation

protocol LyEditImageViewDelegate: class {
    func buttonAction(image: UIImage)
}

class LyEditImageView: UIView, UIGestureRecognizerDelegate {
    private let INIT_CROP_VIEW_SIZE = 60
    private let MINIMAL_CROP_VIEW_SIZE: CGFloat = 30.0
    private let type: Int
    private var ratio: CGFloat?
    weak var delegate: LyEditImageViewDelegate?
    
    private let screenHeight = UIScreen.main.bounds.size.height
    private let screenWidth = UIScreen.main.bounds.size.width
    
    var cropViewPanGesture: UIPanGestureRecognizer = {
        let cropViewPanGesture = UIPanGestureRecognizer()
        cropViewPanGesture.cancelsTouchesInView = false
        cropViewPanGesture.delaysTouchesBegan = false
        cropViewPanGesture.delaysTouchesEnded = false
        return cropViewPanGesture
    }()
    
    var imageView = UIImageView()
    var originImageViewFrame: CGRect = CGRect()
    var cropView = CropView()
    let cropButton: UIButton = {
        let cropButton = UIButton()
        cropButton.setTitle("確定", for: .normal)
        cropButton.setTitleColor(.black, for: .normal)
        cropButton.layer.borderWidth = 2
        cropButton.addTarget(self, action: #selector(acceptButtonAction), for: .touchUpInside)
        return cropButton
    }()
    
    var cropLeftMargin: CGFloat = 0
    var cropTopMargin: CGFloat = 0
    var cropRightMargin: CGFloat = 0
    var cropBottomMargin: CGFloat = 0
    var cropViewConstraints = [NSLayoutConstraint]()
    
    // MARK: init
    private func commitInit() {
        // set cropView
        initCropView()
        // set gesture
        initGestureRecognizer()
        
        self.isMultipleTouchEnabled = true
    }
    
    init(frame: CGRect, type: Int) {
        self.type = type
        switch type {
        case typeValue.square.rawValue:
            ratio = typeValue.square.value
        case typeValue.rectangle.rawValue:
            ratio = typeValue.rectangle.value
        default:
            break
        }
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initWithImage(image: UIImage) {
        initButton()
        self.addSubview(self.imageView)
        imageView.isUserInteractionEnabled = true
        imageView.image = image
        print(image.size)
        let imageSize = CGSize(width: image.size.width, height: image.size.height)
        //將原始imageSize等比縮小放到self.frame中
        var frame = AVMakeRect(aspectRatio: imageSize, insideRect: self.frame)
        //若縮小後的frame還是超出螢幕寬or高，再額外做比例縮小
        if frame.width > screenWidth {
            imageView.image = image.resize(targetSize: CGSize(width: screenWidth, height: screenWidth / 0.75))
            image.draw(in: CGRect(x: 0, y: 0, width: screenWidth, height: screenWidth / 0.75))
            frame.size = imageView.image?.size ?? CGSize()
        }
        //縮小之後的高 + (螢幕高度減掉縮小之後的高)/2 -> 因為imageView之後會center.y，所以要多加上(螢幕高度減掉縮小之後的高)/2做判斷
        if frame.height + (screenHeight - frame.height) / 2 >= cropButton.frame.origin.y - 10 {
            let imageViewHeight = frame.size.height / 4 * 3
            imageView.image = image.resize(targetSize: CGSize(width: (imageViewHeight / frame.size.height) * frame.width, height: imageViewHeight))
            frame.size = imageView.image?.size ?? CGSize()
        }
        print(frame)
        imageView.frame = frame
        imageView.center.x = self.center.x
        imageView.center.y = self.center.y
        originImageViewFrame = imageView.frame
        NSLog("initWithImage %@", NSCoder.string(for: originImageViewFrame))
        commitInit()
    }
    
    private func initGestureRecognizer() {
        cropViewPanGesture.addTarget(self, action: #selector(handlePanGesture(sender:)))
        cropViewPanGesture.delegate = self
        cropView.addGestureRecognizer(cropViewPanGesture)
    }

    private func initCropView() {
        cropView = CropView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        cropView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(cropView)

        //設定cropView上下左右約束值，影響到cropView的寬，高
        cropRightMargin = (CGFloat)(originImageViewFrame.size.width / 2) - (CGFloat)(INIT_CROP_VIEW_SIZE / 2) + (CGFloat)((screenWidth - originImageViewFrame.size.width) / 2)
        cropLeftMargin = cropRightMargin
        //type == 2 長方形 -> /3.125 因為寬高比1050*336 可自行調整，else 正方形
        cropTopMargin = (CGFloat)(originImageViewFrame.size.height / 2) - (CGFloat)(Double(INIT_CROP_VIEW_SIZE) / 2 / Double(ratio ?? 0)) + (CGFloat)((screenHeight - originImageViewFrame.size.height) / 2)
        cropBottomMargin = cropTopMargin
        
        let views = ["cropView":cropView, "imageView":imageView] as [String : UIView]
        //設定constraints
        let Hvfl = String(format: "H:|-%f-[cropView]-%f-|", cropLeftMargin, cropRightMargin)
        let Vvfl = String(format: "V:|-%f-[cropView]-%f-|", cropTopMargin, cropBottomMargin)
        let cropViewHorizentalConstraints = NSLayoutConstraint.constraints(withVisualFormat: Hvfl, options: [], metrics: nil, views: views)
        let cropViewVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: Vvfl, options: [], metrics: nil, views: views)
        cropViewConstraints += cropViewHorizentalConstraints
        cropViewConstraints += cropViewVerticalConstraints
        self.addConstraints(cropViewVerticalConstraints)
        self.addConstraints(cropViewHorizentalConstraints)
        self.layoutIfNeeded()
        
        cropView.initCropViewSubViews()
    }
    
    private func initButton() {
        cropButton.frame = CGRect(x: 10, y: screenHeight - 100, width: screenWidth - 20, height: 50)
        cropButton.layer.cornerRadius = cropButton.frame.height / 10
        self.addSubview(cropButton)
    }
    
    // MARK: Handle Pan Gesture for CropView / ImageView
    @objc fileprivate func handlePanGesture(sender: UIPanGestureRecognizer) {
        if sender.state == UIGestureRecognizer.State.began {
            NSLog("gesture on view %d",cropView.getCropViewTag())
        }
        if sender.state == UIGestureRecognizer.State.changed {
            handleCropViewPanGesture(sender: sender)
        }
        if sender.state == UIGestureRecognizer.State.ended || sender.state == UIGestureRecognizer.State.cancelled {
            cropView.resetHightLightView()
        }
    }
    
    // Check crop view's size incase it too small
    // Ensure crop view will not be moved out of the image view
    func handleCropViewPanGesture(sender: UIPanGestureRecognizer) {
        let tag:Int = cropView.getCropViewTag()
        let view = sender.view
        var translation = sender.translation(in: view?.superview)
        
        if cropView.leftLine.frame.height != cropView.upLine.frame.width {
            print(cropView.leftLine.frame.height, cropView.upLine.frame.width)
        }
        
        switch tag {
        case LyEditImageViewTag.LEFT_UP_TAG.rawValue:
            //y偏移量+上方約束小於imageView.origin.y -> 超出圖片範圍，y偏移量 = imageView.origin.y - 上方約束，讓約束回到imageView範圍內
            if translation.y + cropTopMargin < imageView.frame.origin.y {
                translation.y = imageView.frame.origin.y - cropTopMargin
            }
            //畫面高度 - 上方約束 + y偏移量 + 下方約束 < crop最小size
            if screenHeight - (cropTopMargin + translation.y + cropBottomMargin) < MINIMAL_CROP_VIEW_SIZE {
                translation.y = screenHeight - (cropTopMargin + cropBottomMargin) - MINIMAL_CROP_VIEW_SIZE;
            }
            //為了不要讓cropTopMargin在cropLeftMargin + translation.y <= imageView.frame.origin.x時繼續增加
            if cropLeftMargin + translation.y <= imageView.frame.origin.x && cropLeftMargin > imageView.frame.origin.x {
                cropTopMargin -= (cropLeftMargin - imageView.frame.origin.x) / (ratio ?? 0)
                cropLeftMargin += translation.y
                break
            }
            //如果約束已經到imageView的最邊邊就不動作直接break掉
            if (cropLeftMargin <= imageView.frame.origin.x) && translation.y <= 0 {
                break
            }
            //type == 1 -> 長方形 3.125是因為寬高比1050*336 可自行調整，else 正方形
            cropTopMargin += translation.y / (ratio ?? 0)
            cropLeftMargin += translation.y
            break
        case LyEditImageViewTag.LEFT_DOWN_TAG.rawValue:
            //防止滑到超出imageView底部
            if cropBottomMargin - translation.y < screenHeight - (imageView.frame.origin.y + imageView.frame.size.height) {
                translation.x = -(cropBottomMargin - (screenHeight - (imageView.frame.origin.y + imageView.frame.size.height)))
            }
            //設定最小size
            if screenHeight - (cropTopMargin + cropBottomMargin - translation.y) < MINIMAL_CROP_VIEW_SIZE {
                translation.x = -(MINIMAL_CROP_VIEW_SIZE - (screenHeight - (cropTopMargin + cropBottomMargin)))
            }
            //
            if  cropLeftMargin + translation.x <= imageView.frame.origin.x && cropLeftMargin > imageView.frame.origin.x {
                cropBottomMargin -= (cropLeftMargin - imageView.frame.origin.x) / (ratio ?? 0)
                cropLeftMargin += translation.x
                break
            }
            if (cropLeftMargin <= imageView.frame.origin.x || Int(cropBottomMargin) <= Int(imageView.frame.origin.y)) && translation.x <= 0 {
                break
            }
            cropBottomMargin += translation.x / (ratio ?? 0)
            cropLeftMargin += translation.x
            break
        case LyEditImageViewTag.RIGHT_UP_TAG.rawValue:
            if translation.y + cropTopMargin < imageView.frame.origin.y {
                translation.y = imageView.frame.origin.y - cropTopMargin
            }
            if screenHeight - (cropTopMargin + translation.y + cropBottomMargin) < MINIMAL_CROP_VIEW_SIZE {
                translation.y = screenHeight - (cropTopMargin + cropBottomMargin) - MINIMAL_CROP_VIEW_SIZE;
            }
            if  cropRightMargin + translation.y <= imageView.frame.origin.x && cropRightMargin > imageView.frame.origin.x {
                cropTopMargin -= (cropRightMargin - imageView.frame.origin.x) / (ratio ?? 0)
                cropRightMargin += translation.y
                break
            }
            if (cropRightMargin <= imageView.frame.origin.x) && translation.y <= 0 {
                break
            }
            cropTopMargin += translation.y / (ratio ?? 0)
            cropRightMargin += translation.y
            
            break
        case LyEditImageViewTag.RIGHT_DOWN_TAG.rawValue:
            if cropBottomMargin - translation.y < screenHeight - (imageView.frame.origin.y + imageView.frame.size.height) {
                translation.x = cropBottomMargin - (screenHeight - (imageView.frame.origin.y + imageView.frame.size.height))
            }
            if screenHeight - (cropTopMargin + cropBottomMargin - translation.y) < MINIMAL_CROP_VIEW_SIZE {
                translation.x = MINIMAL_CROP_VIEW_SIZE - (screenHeight - (cropTopMargin + cropBottomMargin))
            }
            if  cropRightMargin - translation.x <= imageView.frame.origin.x && cropRightMargin > imageView.frame.origin.x {
                cropBottomMargin -= (cropRightMargin - imageView.frame.origin.x) / (ratio ?? 0)
                cropRightMargin -= translation.x
                break
            }
            
            if (cropRightMargin <= imageView.frame.origin.x || Int(cropBottomMargin) <= Int(imageView.frame.origin.y)) && translation.x >= 0 {
                break
            }
            cropBottomMargin -= translation.x / (ratio ?? 0)
            cropRightMargin -= translation.x
            break
        default:
            panCropView(translation: translation)
            break
        }
        
        if cropLeftMargin <= imageView.frame.origin.x {
            cropLeftMargin = imageView.frame.origin.x
        }
        if cropRightMargin < imageView.frame.origin.x {
            cropRightMargin = imageView.frame.origin.x
        }
//        if cropTopMargin < imageView.frame.origin.y {
//            cropTopMargin = imageView.frame.origin.y
//        }
//        if cropBottomMargin < imageView.frame.origin.y {
//            cropBottomMargin = imageView.frame.origin.y
//        }
        
        updateCropViewLayout()
        // redraw overLayView after move cropView
        sender.setTranslation(CGPoint.zero, in: view?.superview)
    }
    
    ///設定平移動作
    private func panCropView( translation: CGPoint) {
        var translation = translation

        let right = cropRightMargin
        let left = cropLeftMargin
        let top = cropTopMargin
        let bottom = cropBottomMargin
        
        if left + translation.x < imageView.frame.origin.x {
            translation.x = imageView.frame.origin.x - left
        }
        if right - translation.x < screenWidth - (imageView.frame.origin.x + imageView.frame.size.width) {
            translation.x = right - (screenWidth - (imageView.frame.origin.x + imageView.frame.size.width))
        }
        if top + translation.y < imageView.frame.origin.y {
            translation.y = imageView.frame.origin.y - top
        }
        if bottom - translation.y < screenHeight - (imageView.frame.origin.y + imageView.frame.size.height) {
            translation.y = bottom - (screenHeight - (imageView.frame.origin.y + imageView.frame.size.height))
        }
        if left + translation.x < 0  {
            translation.x = -left
        }
        if right - translation.x < 0 {
            translation.x = right
        }
        if top + translation.y < 0 {
            translation.y = -top
        }
        if bottom - translation.y < 0 {
            translation.y = bottom
        }
        cropRightMargin -= translation.x
        cropLeftMargin += translation.x
        cropBottomMargin -= translation.y
        cropTopMargin += translation.y
    }
    
    private func updateCropViewLayout() {
        // change cropview's constraints
        self.removeConstraints(cropViewConstraints)
        let views = ["cropView":cropView, "imageView":imageView] as [String : UIView]
        let Hvfl = String(format: "H:|-%f-[cropView]-%f-|", cropLeftMargin, cropRightMargin)
        let Vvfl = String(format: "V:|-%f-[cropView]-%f-|", cropTopMargin, cropBottomMargin)
        let cropViewHorizentalConstraints = NSLayoutConstraint.constraints(withVisualFormat: Hvfl, options: [], metrics: nil, views: views)
        let cropViewVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: Vvfl, options: [], metrics: nil, views: views)
        cropViewConstraints += cropViewHorizentalConstraints
        cropViewConstraints += cropViewVerticalConstraints
        self.addConstraints(cropViewVerticalConstraints)
        self.addConstraints(cropViewHorizentalConstraints)
        self.layoutIfNeeded()
        cropView.updateSubView()
    }
    
// MARK: Crop Image
    // Todo: you need to implement this function for custom purpose
    @objc private func acceptButtonAction() {
        cropImage()
    }
    
    private func cropImage() {
        guard let imageViewImage = imageView.image else { return }
        guard let imageSize = imageView.image?.size else { return }
        //拿到cropView在imageView中的frame
        let rect = self.convert(cropView.frame, to: imageView)
        //算出原始image大小跟在畫面中imageView的比例
        let ratio = originImageViewFrame.size.width / (imageSize.width)
        let zoomedRect = CGRect(x: rect.origin.x / ratio, y: rect.origin.y / ratio, width: rect.size.width / ratio, height: rect.size.height / ratio)
        let croppedImage = CropImage.shared.cropImage(image: imageViewImage, rect: zoomedRect)
        
        switch type {
        case typeValue.rectangle.rawValue:
            if croppedImage.size.height > 1050 || croppedImage.size.width > 336 {
                saveImage(currentImage: croppedImage, newSize: CGSize(width: 1050, height: 336), isExeed: true)
            } else {
                saveImage(currentImage: croppedImage)
            }
        case typeValue.square.rawValue:
            if croppedImage.size.height > 600 || croppedImage.size.width > 600 {
                saveImage(currentImage: croppedImage, newSize: CGSize(width: 600, height: 600), isExeed: true)
            } else {
                saveImage(currentImage: croppedImage)
            }
        default:
            break
        }
    }
    
    private func saveImage(currentImage: UIImage, newSize: CGSize = CGSize(), isExeed: Bool = false) {
        //設定新的image size
        let newImage = isExeed ? currentImage.resize(targetSize: newSize) : currentImage
        
        if let imageData = newImage.jpegData(compressionQuality: 1) {
            delegate?.buttonAction(image: UIImage(data: imageData) ?? UIImage())
        }
    }
    
// MARK: GestureRecognizerDelegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return true
    }
}

