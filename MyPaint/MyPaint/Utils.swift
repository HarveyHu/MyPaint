//
//  Utils.swift
//  eBike
//
//  Created by HarveyHu on 3/3/16.
//  Copyright © 2016 HarveyHu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

func prettyLog(_ message: String = "", file:String = #file, function:String = #function, line:Int = #line) {
    
    print("\((file as NSString).lastPathComponent)(\(line)) \(function) \(message)")
}

func dismissViewController(viewController: UIViewController, animated: Bool) {
    if viewController.isBeingDismissed || viewController.isBeingPresented {
        DispatchQueue.main.async {
            dismissViewController(viewController: viewController, animated: animated)
        }
        return
    }
    
    if viewController.presentingViewController != nil {
        viewController.dismiss(animated: animated, completion: nil)
    }
}

func getFrameAvoidStatusBar(frame: CGRect) -> CGRect {
    let statusBarHeight = UIApplication.shared.statusBarFrame.height
    let windowFrame = CGRect(x: frame.origin.x, y: statusBarHeight, width: frame.width, height: frame.height - statusBarHeight)
    return windowFrame
}

func presentAlert(_ viewController: UIViewController, title: String, message: String) {
    #if os(iOS)
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .cancel) { _ in
            })
        
        if let presentedVC = viewController.presentedViewController, presentedVC is UIAlertController {
            presentedVC.dismiss(animated: false, completion: {
                viewController.present(alertView, animated: true, completion: nil)
            })
        } else {
            viewController.present(alertView, animated: true, completion: nil)
        }
    #endif
}

func presentAlert(title: String = "", message: String) {
    #if os(iOS)
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .cancel) { _ in
            })
        if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
        rootViewController.present(alertView, animated: true, completion: nil)
        }
    #endif
}

func presentAlert(title: String = "", message: String, okHandler: (() -> Void)?, cancelHandler: (() -> Void)?) {
    #if os(iOS)
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            cancelHandler?()
            })
        alertView.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            okHandler?()
            })
        
        if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
        rootViewController.present(alertView, animated: true, completion: nil)
        }
    #endif
}


func getRandomNumber(digit: UInt32) -> UInt32 {
    return (arc4random() % digit * 10)
}

func getCachedImage(imageName: String) -> UIImage? {
    
    let imagePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
    if FileManager.default.fileExists(atPath: imagePath) {
        if let image = UIImage(contentsOfFile: imagePath + imageName) {
            return image
        }
    }
    return nil
}

func cacheImage(imageName: String, image: UIImage) -> Bool {
    guard let range = imageName.range(of: ".") else {
        prettyLog("have no extFileName")
        return false
    }
    
    var imageData: Data?
    let extFileName = imageName.substring(from: range.upperBound).lowercased()
    if extFileName == "png" {
        imageData = UIImagePNGRepresentation(image)
    } else if extFileName == "jpg" {
        imageData = UIImageJPEGRepresentation(image, 0)
    }
    
    if let data = imageData {
        let imagePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
        do {
            try data.write(to: URL(string: imagePath + imageName)!, options: .atomicWrite)
        } catch let error {
            prettyLog("\(error)")
            return false
        }
        return true
    }
    return false
}

func getFileNameFromUrl(urlString: String) -> String? {
    let reversedString = String(urlString.characters.reversed())
    guard let range = reversedString.range(of: "/") else {
        prettyLog("have no extFileName")
        return nil
    }
    
    let reversedSubstring = reversedString.substring(to: range.lowerBound)
    return String(reversedSubstring.characters.reversed())
}
