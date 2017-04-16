//
//  UIView+Extension.swift
//  MyPaint
//
//  Created by HarveyHu on 12/04/2017.
//  Copyright © 2017 HarveyHu. All rights reserved.
//

import UIKit

extension UIView {
    func snapShotImage() -> UIImage? {
        var image: UIImage?
        UIGraphicsBeginImageContext(self.frame.size)
        if let context = UIGraphicsGetCurrentContext() {
            self.layer.render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        return image
    }
}
