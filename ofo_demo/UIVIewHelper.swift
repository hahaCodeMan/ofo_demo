//
//  UIVIewHelper.swift
//  ofo_demo
//
//  Created by Risen on 2017/6/18.
//  Copyright © 2017年 Risen. All rights reserved.
//

extension UIView{
   @IBInspectable var borderwidth : CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
             self.layer.borderWidth = newValue
        }
    }
    
  @IBInspectable   var borderColor : UIColor {
        get {
            return UIColor(cgColor: self.layer.borderColor!)
        }
        set {
            self.layer.borderColor = newValue.cgColor
        }
    }
    
   @IBInspectable var cornerRadius : CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = newValue > 0
        }
    }
    
}

@IBDesignable  class MyPreViewLabel : UILabel {
    
    
}

import AVFoundation

func turnTorch()  {
    guard let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeAudio) else {
        return
    }
    

    if device.hasTorch && device.isTorchAvailable{
        try? device.lockForConfiguration()
        if device.torchMode == .off {
            device.torchMode = .on
        } else {
           device.torchMode = .off
        }
        
        
        device.unlockForConfiguration()
    }
}

