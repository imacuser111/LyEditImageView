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
    let CROP_VIEW_TAG = 1001
    let IMAGE_VIEW_TAG = 1002
    static let LEFT_UP_TAG = 1101
    static let LEFT_DOWN_TAG = 1102
    static let RIGHT_UP_TAG = 1103
    static let RIGHT_DOWN_TAG = 1104
    static let LEFT_LINE_TAG = 1105
    static let UP_LINE_TAG = 1106
    static let RIGHT_LINE_TAG = 1107
    static let DOWN_LINE_TAG = 1108
    
    let INIT_CROP_VIEW_SIZE = 100
    let MINIMAL_CROP_VIEW_SIZE: CGFloat = 30.0
    let MINIMUM_ZOOM_SCALE: CGFloat = 1.0
    let MAXIMUM_ZOOM_SCALE: CGFloat = 8.0
    var type = 0
    weak var delegate: LyEditImageViewDelegate?
    
    let screenHeight = UIScreen.main.bounds.size.height
    let screenWidth = UIScreen.main.bounds.size.width
    
    var pinchGestureRecognizer: UIPinchGestureRecognizer!
    var cropViewPanGesture: UIPanGestureRecognizer!
    
    var imageView = UIImageView()
    var touchStartPoint: CGPoint!
    var originImageViewFrame: CGRect!
    var imageZoomScale: CGFloat!
    fileprivate var cropView: CropView!
    
    var cropUpContraint: NSLayoutConstraint!
    var originalImageViewFrame: CGRect!
    
    var cropLeftMargin: CGFloat!
    var cropTopMargin: CGFloat!
    var cropRightMargin: CGFloat!
    var cropBottomMargin: CGFloat!
    var cropViewConstraints = [NSLayoutConstraint]()
    var cropLeftToImage: CGFloat!
    var cropTopToImage: CGFloat!
    var cropRightToImage: CGFloat!
    var cropBottomToImage: CGFloat!
    var originalSubViewFrame:CGRect!
    var cropViewConstraintsRatio: CGFloat!
    
    // MARK: init
    private func commitInit() {
        // set cropView
        initCropView()
        // set gesture
        initGestureRecognizer()
        
        initButton()
        
        self.isMultipleTouchEnabled = true
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initWithImage(image: UIImage) {
        imageView.tag = IMAGE_VIEW_TAG;
        self.addSubview(self.imageView)
        imageView.isUserInteractionEnabled = true;
        
        imageView.image = image
        imageView.frame = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height);
        let frame = AVMakeRect(aspectRatio: imageView.frame.size, insideRect: self.frame);
        imageView.frame = frame
        originImageViewFrame = frame
        NSLog("initWithImage %@", NSCoder.string(for: originImageViewFrame))
        imageZoomScale = 1.0
        commitInit()
    }
    
    private func initGestureRecognizer() {
        cropViewPanGesture = UIPanGestureRecognizer()
        cropViewPanGesture.addTarget(self, action: #selector(handlePanGesture(sender:)))
        cropViewPanGesture.cancelsTouchesInView = false;
        cropViewPanGesture.delaysTouchesBegan = false
        cropViewPanGesture.delaysTouchesEnded = false
        cropViewPanGesture.delegate = self
        cropView.addGestureRecognizer(cropViewPanGesture)
    }

    private func initCropView() {
        
        cropView = CropView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        cropView.tag = CROP_VIEW_TAG;
        cropView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(cropView)

        cropRightMargin = (CGFloat)(originImageViewFrame.size.width / 2) - (CGFloat)(INIT_CROP_VIEW_SIZE / 2)
        cropLeftMargin = cropRightMargin
        if type == 2 {
            cropTopMargin = (CGFloat)(originImageViewFrame.size.height / 2) - (CGFloat)(Double(INIT_CROP_VIEW_SIZE) / 2 / 3.125) + (CGFloat)((screenHeight - originImageViewFrame.size.height) / 2)
        } else {
            cropTopMargin = (CGFloat)(originImageViewFrame.size.height / 2) - (CGFloat)(INIT_CROP_VIEW_SIZE / 2) + (CGFloat)((screenHeight - originImageViewFrame.size.height) / 2)
        }
        cropBottomMargin = cropTopMargin
        
        let views = ["cropView":cropView!, "imageView":imageView] as [String : UIView]
        let Hvfl = String(format: "H:|-%f-[cropView]-%f-|", cropLeftMargin, cropRightMargin);
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
        let cropButton = UIButton()
        cropButton.frame = CGRect(x: screenWidth / 4 - 25, y: screenHeight - 100, width: 50, height: 50)
        cropButton.setImage(UIImage(named: "accept.png"), for: UIControl.State.normal)
        cropButton.addTarget(self, action: #selector(acceptButtonAction), for: .touchUpInside)
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
        switch tag {
        case LyEditImageView.LEFT_UP_TAG:
            //y偏移量+上方約束小於imageView.origin.y -> 超出圖片範圍，y偏移量 = imageView.origin.y - 上方約束，讓約束回到imageView範圍內
            if translation.y + cropTopMargin < imageView.frame.origin.y {
                translation.y = imageView.frame.origin.y - cropTopMargin
            }
            //畫面高度 - 上方約束 + y偏移量 + 下方約束 < crop最小size
            if screenHeight - (cropTopMargin + translation.y + cropBottomMargin) < MINIMAL_CROP_VIEW_SIZE {
                translation.y = screenHeight - (cropTopMargin + cropBottomMargin) - MINIMAL_CROP_VIEW_SIZE;
            }
            //為了不要讓cropTopMargin在cropLeftMargin + translation.y <= imageView.frame.origin.x時繼續增加
            if cropLeftMargin + translation.y <= imageView.frame.origin.x && cropLeftMargin > 0 {
                if type == 2 {
                    cropTopMargin! -= cropLeftMargin / 3.125
                } else {
                    cropTopMargin! -= cropLeftMargin
                }
                cropLeftMargin! += translation.y
                break
            }
            if (cropTopMargin <= 0 || cropLeftMargin <= 0) && translation.y <= 0 {
                break
            }
            if type == 2 {
                cropTopMargin! += translation.y / 3.125
            } else {
                cropTopMargin! += translation.y
            }
            cropLeftMargin! += translation.y
            break
        case LyEditImageView.LEFT_DOWN_TAG:
            //防止滑到超出imageView底部
            if cropBottomMargin - translation.y < screenHeight - (imageView.frame.origin.y + imageView.frame.size.height) {
                translation.x = -(cropBottomMargin - (screenHeight - (imageView.frame.origin.y + imageView.frame.size.height)))
            }
            //設定最小size
            if screenHeight - (cropTopMargin + cropBottomMargin - translation.y) < MINIMAL_CROP_VIEW_SIZE {
                translation.x = -(MINIMAL_CROP_VIEW_SIZE - (screenHeight - (cropTopMargin + cropBottomMargin)))
            }
            //
            if  cropLeftMargin + translation.x <= imageView.frame.origin.x && cropLeftMargin > 0 {
                if type == 2 {
                    cropBottomMargin! -= cropLeftMargin / 3.125
                } else {
                    cropBottomMargin! -= cropLeftMargin
                }
                cropLeftMargin! += translation.x
                break
            }
            if (cropLeftMargin <= 0 || cropBottomMargin <= 0) && translation.x <= 0 {
                break
            }
            if type == 2 {
                cropBottomMargin! += translation.x / 3.125
            } else {
                cropBottomMargin! += translation.x
            }
            cropLeftMargin! += translation.x
            break
        case LyEditImageView.RIGHT_UP_TAG:
            if translation.y + cropTopMargin < imageView.frame.origin.y {
                translation.y = imageView.frame.origin.y - cropTopMargin
            }
            if screenHeight - (cropTopMargin + translation.y + cropBottomMargin) < MINIMAL_CROP_VIEW_SIZE {
                translation.y = screenHeight - (cropTopMargin + cropBottomMargin) - MINIMAL_CROP_VIEW_SIZE;
            }
            if  cropRightMargin + translation.y <= imageView.frame.origin.x && cropRightMargin > 0 {
                if type == 2 {
                    cropTopMargin! -= cropRightMargin / 3.125
                } else {
                    cropTopMargin! -= cropRightMargin
                }
                cropRightMargin! += translation.y
                break
            }
            if (cropRightMargin <= 0 || cropTopMargin <= 0) && translation.y <= 0 {
                break
            }
            if type == 2 {
                cropTopMargin! += translation.y / 3.125
            } else {
                cropTopMargin! += translation.y
            }
            cropRightMargin! += translation.y
            
            break
        case LyEditImageView.RIGHT_DOWN_TAG:
            if cropBottomMargin - translation.y < screenHeight - (imageView.frame.origin.y + imageView.frame.size.height) {
                translation.x = cropBottomMargin - (screenHeight - (imageView.frame.origin.y + imageView.frame.size.height))
            }
            if screenHeight - (cropTopMargin + cropBottomMargin - translation.y) < MINIMAL_CROP_VIEW_SIZE {
                translation.x = MINIMAL_CROP_VIEW_SIZE - (screenHeight - (cropTopMargin + cropBottomMargin))
            }
            if  cropRightMargin - translation.x <= 0 && cropRightMargin > 0 {
                if type == 2 {
                    cropBottomMargin! -= cropRightMargin / 3.125
                } else {
                    cropBottomMargin! -= cropRightMargin
                }
                cropRightMargin! -= translation.x
                break
            }
            if (cropRightMargin <= 0 || cropBottomMargin <= 0) && translation.x >= 0 {
                break
            }
            if type == 2 {
                cropBottomMargin! -= translation.x / 3.125
            } else {
                cropBottomMargin! -= translation.x
            }
            cropRightMargin! -= translation.x
            break
        default:
            panCropView(translation: translation)
            break
        }
        
        if cropLeftMargin <= 0 {
            cropLeftMargin = 0;
        }
        if cropRightMargin < 0 {
            cropRightMargin = 0;
        }
        if cropTopMargin < 0 {
            cropTopMargin = 0;
        }
        if cropBottomMargin < 0 {
            cropBottomMargin = 0;
        }
        
        updateCropViewLayout()
        // redraw overLayView after move cropView
        sender.setTranslation(CGPoint.zero, in: view?.superview)
    }
    
    private func panCropView( translation: CGPoint) {
        var translation = translation

        let right = cropRightMargin
        let left = cropLeftMargin
        let top = cropTopMargin
        let bottom = cropBottomMargin
        
        if  left! + translation.x < imageView.frame.origin.x {
            translation.x = imageView.frame.origin.x - left!
        }
        if right! - translation.x < screenWidth - (imageView.frame.origin.x + imageView.frame.size.width) {
            translation.x = right! - (screenWidth - (imageView.frame.origin.x + imageView.frame.size.width))
        }
        if top! + translation.y < imageView.frame.origin.y {
            translation.y = imageView.frame.origin.y - top!
        }
        if bottom! - translation.y < screenHeight - (imageView.frame.origin.y + imageView.frame.size.height) {
            translation.y = bottom! - (screenHeight - (imageView.frame.origin.y + imageView.frame.size.height))
        }
        if left! + translation.x < 0  {
            translation.x = -left!
        }
        if right! - translation.x < 0 {
            translation.x = right!
        }
        if top! + translation.y < 0 {
            translation.y = -top!
        }
        if bottom! - translation.y < 0 {
            translation.y = bottom!
        }
        cropRightMargin! -= translation.x
        cropLeftMargin! += translation.x
        cropBottomMargin! -= translation.y
        cropTopMargin! += translation.y
    }
    
    private func updateCropViewLayout() {
        // change cropview's constraints
        self.removeConstraints(cropViewConstraints)
        let views = ["cropView":cropView!, "imageView":imageView] as [String : UIView]
        let Hvfl = String(format: "H:|-%f-[cropView]-%f-|", cropLeftMargin, cropRightMargin);
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
        let rect = self.convert(cropView.frame, to: imageView)
        let imageSize = imageView.image?.size
        let ratio = originImageViewFrame.size.width / (imageSize?.width)!
        let zoomedRect = CGRect(x: rect.origin.x / ratio, y: rect.origin.y / ratio, width: rect.size.width / ratio, height: rect.size.height / ratio)
        let croppedImage = cropImage(image: imageView.image!, toRect: zoomedRect)
    
        if type == 2 {
            saveImage(currentImage: croppedImage, newSize: CGSize(width: 1050, height: 336), imageName: "test")
        } else {
            saveImage(currentImage: croppedImage, newSize: CGSize(width: 600, height: 600), imageName: "test")
        }
    }

    private func cropImage(image: UIImage, toRect rect: CGRect) -> UIImage {
        let imageRef = image.cgImage?.cropping(to: rect)
        let croppedImage = UIImage(cgImage: imageRef!)
        return croppedImage
    }
    
    private func saveImage(currentImage: UIImage, newSize: CGSize, imageName: String){
        //壓縮圖片尺寸
        UIGraphicsBeginImageContext(newSize)
        currentImage.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))

        if let newImage = UIGraphicsGetImageFromCurrentImageContext() {
            if let imageData = newImage.jpegData(compressionQuality: 1) {
                delegate?.buttonAction(image: UIImage(data: imageData) ?? UIImage())
            }
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

