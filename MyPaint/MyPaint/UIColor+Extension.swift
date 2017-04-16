//
//  UIColor+CustomColors.swift
//  eBike
//
//  Created by HarveyHu on 3/9/16.
//  Copyright © 2016 HarveyHu. All rights reserved.
//

import UIKit

extension UIColor {
    class func samepleColor() -> UIColor {
        return UIColor.hexToColor(hex: 0xFF335500)
    }
    
    class func hexToColor(hex: UInt32) -> UIColor {
        return UIColor(red: CGFloat((hex & 0xFF0000) >> 16) / 255, green: CGFloat((hex & 0xFF00) >> 8) / 255 ,
            blue: CGFloat(hex & 0xFF) / 255 , alpha: CGFloat((hex & 0xFF000000) >> 24) / 255)
    }
    
    class func hexStringToColor(hexString: String) -> UIColor {
        var rgbValue: UInt32 = 0
        let scanner = Scanner(string: hexString)
        scanner.scanLocation = 0
        scanner.scanHexInt32(&rgbValue)
        return UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16)/255.0,
            green: CGFloat((rgbValue & 0xFF00) >> 8)/255.0,
            blue: CGFloat(rgbValue & 0xFF)/255.0,
            alpha: 1.0)
    }
    
    func tinyImage() -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width:1.0, height:1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(self.cgColor)
        context!.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}
