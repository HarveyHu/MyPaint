//
//  CanvasViewController.swift
//  MyPaint
//
//  Created by HarveyHu on 19/03/2017.
//  Copyright © 2017 HarveyHu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CanvasViewController: BaseViewController {
    var startPoint = CGPoint.zero
    let viewModel = CanvasViewModel()
    var bzPath: UIBezierPath?
    
    let canvasView = UIView()
    
    let topToolBoxView = UIView()
    let cameraButton = UIButton()
    let backButton = UIButton()
    let eraserButton = UIButton()
    let opacityLabel = UILabel()
    let opacitySlider = UISlider()
    let strokeWidthLabel = UILabel()
    let strokeWidthSlider = UISlider()
    let segmentedControl = UISegmentedControl()
    
    let bottomToolBoxView = UIView()
    let lineButton = UIButton()
    let rectangleButton = UIButton()
    let ellipseButton = UIButton()
    let freeLineButton = UIButton()
    let triangleButton = UIButton()
    let trashcanButton = UIButton()
    
    let redButton = UIButton()
    let yellowButton = UIButton()
    let purpleButton = UIButton()
    let greenButton = UIButton()
    let blueButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.viewModel.updateLayersToView()
    }

    override func setUI() {
        super.setUI()
        self.view.addSubview(canvasView)
        self.view.addSubview(topToolBoxView)
        self.view.addSubview(bottomToolBoxView)
        
        self.topToolBoxView.addSubview(cameraButton)
        self.topToolBoxView.addSubview(backButton)
        self.topToolBoxView.addSubview(eraserButton)
        self.topToolBoxView.addSubview(opacityLabel)
        self.topToolBoxView.addSubview(opacitySlider)
        self.topToolBoxView.addSubview(strokeWidthLabel)
        self.topToolBoxView.addSubview(strokeWidthSlider)
        self.topToolBoxView.addSubview(segmentedControl)
        
        self.bottomToolBoxView.addSubview(lineButton)
        self.bottomToolBoxView.addSubview(rectangleButton)
        self.bottomToolBoxView.addSubview(ellipseButton)
        self.bottomToolBoxView.addSubview(freeLineButton)
        self.bottomToolBoxView.addSubview(triangleButton)
        self.bottomToolBoxView.addSubview(trashcanButton)
        self.bottomToolBoxView.addSubview(redButton)
        self.bottomToolBoxView.addSubview(yellowButton)
        self.bottomToolBoxView.addSubview(purpleButton)
        self.bottomToolBoxView.addSubview(greenButton)
        self.bottomToolBoxView.addSubview(blueButton)
        
        
        lineButton.setImage(UIImage(named: "straight_line"), for: .normal)
        lineButton.setImage(UIImage(named: "straight_line_pink"), for: .highlighted)
        
        rectangleButton.setImage(UIImage(named: "rectangle"), for: .normal)
        rectangleButton.setImage(UIImage(named: "rectangle_pink"), for: .highlighted)
        
        ellipseButton.setImage(UIImage(named: "circle"), for: .normal)
        ellipseButton.setImage(UIImage(named: "circle_pink"), for: .highlighted)
        
        freeLineButton.setImage(UIImage(named: "pen"), for: .normal)
        freeLineButton.setImage(UIImage(named: "pen_pink"), for: .highlighted)
        
        triangleButton.setImage(UIImage(named: "triangle"), for: .normal)
        triangleButton.setImage(UIImage(named: "triangle_pink"), for: .highlighted)
        
        trashcanButton.setImage(UIImage(named: "trashcan"), for: .normal)
        trashcanButton.setImage(UIImage(named: "trashcan_pink"), for: .highlighted)
        
        cameraButton.setImage(UIImage(named: "camera"), for: .normal)
        cameraButton.setImage(UIImage(named: "camera_pink"), for: .highlighted)
        
        backButton.setImage(UIImage(named: "back"), for: .normal)
        backButton.setImage(UIImage(named: "back_pink"), for: .highlighted)
        
        eraserButton.setImage(UIImage(named: "eraser"), for: .normal)
        eraserButton.setImage(UIImage(named: "eraser_pink"), for: .highlighted)
        
        opacityLabel.text = "opacity:"
        opacitySlider.maximumValue = 1.0
        opacitySlider.minimumValue = 0.0
        opacitySlider.value = self.viewModel.opacity
        
        strokeWidthLabel.text = "width:"
        strokeWidthSlider.maximumValue = 50.0
        strokeWidthSlider.minimumValue = 1.0
        strokeWidthSlider.value = self.viewModel.lineWidth
        
        segmentedControl.insertSegment(withTitle: "fill", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "line", at: 1, animated: true)
        segmentedControl.selectedSegmentIndex = 0
        
        redButton.setBackgroundImage(UIColor.red.tinyImage(), for: .normal)
        yellowButton.setBackgroundImage(UIColor.yellow.tinyImage(), for: .normal)
        purpleButton.setBackgroundImage(UIColor.purple.tinyImage(), for: .normal)
        greenButton.setBackgroundImage(UIColor.green.tinyImage(), for: .normal)
        blueButton.setBackgroundImage(UIColor.blue.tinyImage(), for: .normal)
        
        changeColorButtonBorder(button: redButton)
        changeButtonBorder(button: lineButton)
    }
    
    override func setUIConstraints() {
        super.setUIConstraints()
        
        self.topToolBoxView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(80.0)
        }
        
        self.canvasView.snp.makeConstraints { (make) in
            make.top.equalTo(self.topToolBoxView.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-80)
        }
        
        self.bottomToolBoxView.snp.makeConstraints { (make) in
            make.top.equalTo(self.canvasView.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        self.lineButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(10)
            make.height.equalToSuperview().offset(-20)
            make.width.equalTo(lineButton.snp.height)
        }
        
        self.rectangleButton.snp.makeConstraints { (make) in
            make.top.equalTo(lineButton)
            make.leading.equalTo(lineButton.snp.trailing).offset(10)
            make.width.equalTo(lineButton)
            make.height.equalTo(lineButton)
        }
        
        self.ellipseButton.snp.makeConstraints { (make) in
            make.top.equalTo(lineButton)
            make.leading.equalTo(rectangleButton.snp.trailing).offset(10)
            make.width.equalTo(lineButton)
            make.height.equalTo(lineButton)
        }
        
        self.freeLineButton.snp.makeConstraints { (make) in
            make.top.equalTo(lineButton)
            make.leading.equalTo(ellipseButton.snp.trailing).offset(10)
            make.width.equalTo(lineButton)
            make.height.equalTo(lineButton)
        }
        
        self.triangleButton.snp.makeConstraints { (make) in
            make.top.equalTo(lineButton)
            make.leading.equalTo(freeLineButton.snp.trailing).offset(10)
            make.width.equalTo(lineButton)
            make.height.equalTo(lineButton)
        }
        
        self.trashcanButton.snp.makeConstraints { (make) in
            make.top.equalTo(lineButton)
            make.trailing.equalToSuperview().offset(-10)
            make.width.equalTo(lineButton)
            make.height.equalTo(lineButton)
        }
        
        self.redButton.snp.makeConstraints { (make) in
            make.top.equalTo(lineButton)
            make.trailing.equalTo(trashcanButton.snp.leading)
            make.width.equalTo(lineButton)
            make.height.equalTo(lineButton)
        }
        
        self.yellowButton.snp.makeConstraints { (make) in
            make.top.equalTo(lineButton)
            make.trailing.equalTo(redButton.snp.leading)
            make.width.equalTo(lineButton)
            make.height.equalTo(lineButton)
        }
        
        self.purpleButton.snp.makeConstraints { (make) in
            make.top.equalTo(lineButton)
            make.trailing.equalTo(yellowButton.snp.leading)
            make.width.equalTo(lineButton)
            make.height.equalTo(lineButton)
        }
        
        self.greenButton.snp.makeConstraints { (make) in
            make.top.equalTo(lineButton)
            make.trailing.equalTo(purpleButton.snp.leading)
            make.width.equalTo(lineButton)
            make.height.equalTo(lineButton)
        }
        
        self.blueButton.snp.makeConstraints { (make) in
            make.top.equalTo(lineButton)
            make.trailing.equalTo(greenButton.snp.leading)
            make.width.equalTo(lineButton)
            make.height.equalTo(lineButton)
        }
        
        self.cameraButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.width.equalTo(self.cameraButton.snp.height)
            make.height.equalToSuperview().offset(-20)
        }
        
        self.backButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(10)
            make.width.equalTo(self.backButton.snp.height)
            make.height.equalToSuperview().offset(-20)
        }
        
        self.eraserButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.leading.equalTo(backButton.snp.trailing).offset(10)
            make.width.equalTo(self.backButton.snp.height)
            make.height.equalToSuperview().offset(-20)
        }
        
        self.opacityLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.leading.equalTo(eraserButton.snp.trailing).offset(10)
            make.width.equalTo(65.0)
            make.height.equalToSuperview().offset(-20)
        }
        
        self.opacitySlider.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.leading.equalTo(opacityLabel.snp.trailing).offset(10)
            make.width.equalTo(100.0)
            make.height.equalToSuperview().offset(-20)
        }
        
        self.strokeWidthLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.leading.equalTo(opacitySlider.snp.trailing).offset(10)
            make.width.equalTo(50.0)
            make.height.equalToSuperview().offset(-20)
        }
        
        self.strokeWidthSlider.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.leading.equalTo(strokeWidthLabel.snp.trailing).offset(10)
            make.width.equalTo(100.0)
            make.height.equalToSuperview().offset(-20)
        }
        
        self.segmentedControl.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(cameraButton.snp.leading).offset(-10)
            make.width.equalTo(100.0)
            make.height.equalTo(20.0)
        }
    }
    
    override func setUIEvents() {
        super.setUIEvents()
        
        // pan
        let panGR = UIPanGestureRecognizer()
        panGR.rx.event.asControlEvent().asDriver()
            .drive(onNext: {[weak self] (pan) in
                
            self?.viewModel.handlePan(pan)
                
        }, onCompleted: nil, onDisposed: nil)
        .addDisposableTo(disposeBag)
        self.canvasView.addGestureRecognizer(panGR)
        
        
        // get sublayers
        _ = viewModel.layerSubject.asDriver(onErrorJustReturn: [CAShapeLayer()])
            .drive(onNext: {[weak self] (layers) in
            
            self?.canvasView.layer.sublayers = layers
            self?.canvasView.layer.setNeedsLayout()
        }, onCompleted: nil, onDisposed: nil)
        
        
        // button tap events
        self.lineButton.rx.tap.asDriver()
            .drive(onNext: {[weak self] (tap) in
                self?.changeButtonBorder(button: self!.lineButton)
                self?.viewModel.shape = .line
                }, onCompleted: nil, onDisposed: nil)
            .addDisposableTo(disposeBag)
        
        self.rectangleButton.rx.tap.asDriver()
            .drive(onNext: {[weak self] (tap) in
                self?.changeButtonBorder(button: self!.rectangleButton)
                self?.viewModel.shape = .rectangle
                }, onCompleted: nil, onDisposed: nil)
            .addDisposableTo(disposeBag)
        
        self.ellipseButton.rx.tap.asDriver()
            .drive(onNext: {[weak self] (tap) in
                self?.changeButtonBorder(button: self!.ellipseButton)
                self?.viewModel.shape = .ellipse
                }, onCompleted: nil, onDisposed: nil)
            .addDisposableTo(disposeBag)
        
        self.freeLineButton.rx.tap.asDriver()
            .drive(onNext: {[weak self] (tap) in
                self?.changeButtonBorder(button: self!.freeLineButton)
                self?.viewModel.shape = .freeLine
                }, onCompleted: nil, onDisposed: nil)
            .addDisposableTo(disposeBag)
        
        self.triangleButton.rx.tap.asDriver()
            .drive(onNext: {[weak self] (tap) in
                self?.changeButtonBorder(button: self!.triangleButton)
                self?.viewModel.shape = .triangle
                }, onCompleted: nil, onDisposed: nil)
            .addDisposableTo(disposeBag)
        
        self.trashcanButton.rx.tap.asDriver()
            .drive(onNext: {[weak self] (tap) in
                self?.bottomAlert(sender: self!.trashcanButton)
                }, onCompleted: nil, onDisposed: nil)
            .addDisposableTo(disposeBag)
        
        // color buttons
        self.redButton.rx.tap.asDriver()
            .drive(onNext: {[weak self] (tap) in
                self?.changeColorButtonBorder(button: self!.redButton)
                self?.changeColor(segmentedControllIndex: self!.segmentedControl.selectedSegmentIndex, color: UIColor.red)
                }, onCompleted: nil, onDisposed: nil)
            .addDisposableTo(disposeBag)
        
        self.yellowButton.rx.tap.asDriver()
            .drive(onNext: {[weak self] (tap) in
                self?.changeColorButtonBorder(button: self!.yellowButton)
                self?.changeColor(segmentedControllIndex: self!.segmentedControl.selectedSegmentIndex, color: UIColor.yellow)
                }, onCompleted: nil, onDisposed: nil)
            .addDisposableTo(disposeBag)
        
        self.purpleButton.rx.tap.asDriver()
            .drive(onNext: {[weak self] (tap) in
                self?.changeColorButtonBorder(button: self!.purpleButton)
                self?.changeColor(segmentedControllIndex: self!.segmentedControl.selectedSegmentIndex, color: UIColor.purple)
                }, onCompleted: nil, onDisposed: nil)
            .addDisposableTo(disposeBag)
        
        self.greenButton.rx.tap.asDriver()
            .drive(onNext: {[weak self] (tap) in
                self?.changeColorButtonBorder(button: self!.greenButton)
                self?.changeColor(segmentedControllIndex: self!.segmentedControl.selectedSegmentIndex, color: UIColor.green)
                }, onCompleted: nil, onDisposed: nil)
            .addDisposableTo(disposeBag)
        
        self.blueButton.rx.tap.asDriver()
            .drive(onNext: {[weak self] (tap) in
                self?.changeColorButtonBorder(button: self!.blueButton)
                self?.changeColor(segmentedControllIndex: self!.segmentedControl.selectedSegmentIndex,
                                  color: UIColor.blue)
                }, onCompleted: nil, onDisposed: nil)
            .addDisposableTo(disposeBag)
        
        // topToolbox
        self.cameraButton.rx.tap.asDriver()
            .drive(onNext: {[weak self] (tap) in
                if let image = self?.canvasView.snapShotImage() {
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                }
                }, onCompleted: nil, onDisposed: nil)
            .addDisposableTo(disposeBag)
        
        self.backButton.rx.tap.asDriver()
            .drive(onNext: {[weak self] (tap) in
                self?.viewModel.back()
                }, onCompleted: nil, onDisposed: nil)
            .addDisposableTo(disposeBag)
        
        self.eraserButton.rx.tap.asDriver()
            .drive(onNext: {[weak self] (tap) in
                self?.changeButtonBorder(button: self!.eraserButton)
                self?.viewModel.shape = .eraser
                }, onCompleted: nil, onDisposed: nil)
            .addDisposableTo(disposeBag)
        
        self.opacitySlider.rx.value.asDriver()
            .drive(onNext: {[weak self] (value) in
                self?.viewModel.opacity = value
                }, onCompleted: nil, onDisposed: nil)
            .addDisposableTo(disposeBag)
        
        self.strokeWidthSlider.rx.value.asDriver()
            .drive(onNext: {[weak self] (value) in
                self?.viewModel.lineWidth = value
                }, onCompleted: nil, onDisposed: nil)
            .addDisposableTo(disposeBag)
        
        self.segmentedControl.rx.selectedSegmentIndex.asDriver()
        .drive(onNext: {[weak self] (index) in
            if self!.segmentedControl.selectedSegmentIndex == 0 {
                self?.changeColorButtonBorder(button: self!.getButtonByColor(color: self!.viewModel.fillColor))
            } else {
                self?.changeColorButtonBorder(button: self!.getButtonByColor(color: self!.viewModel.strokeColor))
            }
        }, onCompleted: nil, onDisposed: nil)
        .addDisposableTo(disposeBag)
    }
    
    private func changeButtonBorder(button: UIButton) {
        self.lineButton.layer.borderWidth = 0.0
        self.rectangleButton.layer.borderWidth = 0.0
        self.ellipseButton.layer.borderWidth = 0.0
        self.freeLineButton.layer.borderWidth = 0.0
        self.triangleButton.layer.borderWidth = 0.0
        self.eraserButton.layer.borderWidth = 0.0
        
        button.layer.borderWidth = 3.0
        button.layer.borderColor = UIColor.red.cgColor
    }
    
    private func changeColorButtonBorder(button: UIButton) {
        self.redButton.layer.borderWidth = 0.0
        self.yellowButton.layer.borderWidth = 0.0
        self.purpleButton.layer.borderWidth = 0.0
        self.greenButton.layer.borderWidth = 0.0
        self.blueButton.layer.borderWidth = 0.0
        
        button.layer.borderWidth = 5.0
        button.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    private func bottomAlert(sender: UIButton) {
        let alertController = UIAlertController(
            title: "",
            message: "All drawings & stickers will be deleted.",
            preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            
        } )
        alertController.addAction(cancelAction)
        
        let okAction = UIAlertAction(title: "Delete All", style: .destructive, handler: {[weak self] (action) in
            self?.viewModel.removeAll()
        } )
        alertController.addAction(okAction)
        
        if let popoverController = alertController.popoverPresentationController, UIDevice.current.userInterfaceIdiom == .pad {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
            popoverController.permittedArrowDirections = .any
        }
        
        self.present(
            alertController,
            animated: true,
            completion: nil)
    }
    
    func changeColor(segmentedControllIndex: Int, color: UIColor) {
        if self.segmentedControl.selectedSegmentIndex == 0 {
            self.viewModel.fillColor = color
        } else {
            self.viewModel.strokeColor = color
        }
    }
    
    func getButtonByColor(color: UIColor) -> UIButton {
        switch color {
        case UIColor.red:
            return redButton
        case UIColor.yellow:
            return yellowButton
        case UIColor.purple:
            return purpleButton
        case UIColor.green:
            return greenButton
        case UIColor.blue:
            return blueButton
        default:
            return blueButton
        }
    }
}

