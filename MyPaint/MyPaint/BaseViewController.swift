//
//  BaseViewController.swift
//  TeaBox
//
//  Created by HarveyHu on 4/19/16.
//  Copyright © 2016 HarveyHu. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

protocol UISetting {
    func setUI()
    func setUIConstraints()
    func setUIEvents()
}

class BaseViewController: UIViewController, UISetting {
    let disposeBag = DisposeBag()
    var frameBeforeKeyboardShowUp: CGRect?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUI()
        self.setUIConstraints()
        self.setUIEvents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        registerForKeyboardNotifications()
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        deregisterForKeyboardNotifications()
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUI() {
        self.view.backgroundColor = UIColor.white
    }
    func setUIConstraints() {}
    func setUIEvents() {
        let tapGR1 = UITapGestureRecognizer()
        tapGR1.rx.event.asDriver().drive(onNext: {[weak self] (tap) in
            self?.view.endEditing(true)
            }, onCompleted: nil, onDisposed: nil)
            .addDisposableTo(disposeBag)
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tapGR1)
    }
    
    // MARK: - Keyboard
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown), name: NSNotification.Name.UIKeyboardDidShow, object:nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func deregisterForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // Called when the UIKeyboardDidShowNotification is sent.
    @objc func keyboardWasShown(aNotification: NSNotification)
    {
        guard let info = aNotification.userInfo, let activeView = aNotification.object as? UIView else {
            return
        }
        
        let kbSize = (info[UIKeyboardFrameBeginUserInfoKey] as AnyObject).cgRectValue.size
        var aRect = activeView.frame
        aRect.size.height = aRect.size.height - kbSize.height
        
        if !aRect.contains(activeView.frame.origin) {
            
            frameBeforeKeyboardShowUp = CGRect(origin: activeView.frame.origin, size: activeView.frame.size)
            
            self.view.frame = aRect
        }
    }
    
    // Called when the UIKeyboardWillHideNotification is sent
    @objc func keyboardWillBeHidden(aNotification: NSNotification)
    {
        if let frame = self.frameBeforeKeyboardShowUp {
            self.view.frame = frame
        }
    }
}
