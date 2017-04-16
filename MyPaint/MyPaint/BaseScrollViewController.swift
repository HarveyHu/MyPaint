//
//  BaseScrollViewController.swift
//  TeaBox
//
//  Created by HarveyHu on 4/26/16.
//  Copyright © 2016 HarveyHu. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

class BaseScrollViewController: BaseViewController {
    let contentView = UIView()
    let scrollView = UIScrollView()
    var originalContentInsets = UIEdgeInsets.zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        originalContentInsets = scrollView.contentInset
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func setUI() {
        super.setUI()
        self.scrollView.addSubview(contentView)
        self.view.addSubview(scrollView)
        
    }
    
    override func setUIConstraints() {
        super.setUIConstraints()
        
        scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view)
            make.bottom.equalTo(self.view)
            make.leading.equalTo(self.view)
            make.trailing.equalTo(self.view)
        }
        
        contentView.snp.makeConstraints { (make) in
            make.top.equalTo(self.scrollView)
            make.leading.equalTo(self.scrollView)
            make.trailing.equalTo(self.scrollView)
            make.bottom.equalTo(self.scrollView)
        }
    }
    
    override func setUIEvents() {
        super.setUIEvents()
        // remove keyboard when click on contentView
        let tapGR1 = UITapGestureRecognizer()
        tapGR1.rx.event.asDriver().drive(onNext: {[weak self] (tap) in
            self?.view.endEditing(true)
        }, onCompleted: nil, onDisposed: nil)
            .addDisposableTo(disposeBag)
        self.contentView.isUserInteractionEnabled = true
        self.contentView.addGestureRecognizer(tapGR1)
    }
    
    // MARK: - Keyboard
    @objc override func keyboardWasShown(aNotification: NSNotification)
    {
        guard let info = aNotification.userInfo else {
            return
        }
        let kbSize = (info[UIKeyboardFrameBeginUserInfoKey] as AnyObject).cgRectValue.size
        prettyLog("originalContentInsets:\(originalContentInsets)")
        prettyLog("contentSize:\(scrollView.contentSize)")
        let contentInsets = UIEdgeInsetsMake(originalContentInsets.top, originalContentInsets.left, kbSize.height, originalContentInsets.right)
        prettyLog("contentInset:\(contentInsets)")
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc override func keyboardWillBeHidden(aNotification: NSNotification)
    {
        prettyLog("contentInsets:\(originalContentInsets)")
        let contentInsets = originalContentInsets
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
    }
}
