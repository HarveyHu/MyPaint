//
//  CanvasViewModel.swift
//  MyPaint
//
//  Created by HarveyHu on 19/03/2017.
//  Copyright © 2017 HarveyHu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CanvasViewModel {
    private let disposeBag = DisposeBag()
    private var layers = Array<CAShapeLayer>()
    private var bzPath: UIBezierPath?
    private var startPoint = CGPoint.zero
    let layerSubject = PublishSubject<[CAShapeLayer]>()
    let model = UserDefault()
    
    var fillColor = UIColor.red
    var strokeColor = UIColor.blue
    var layerDictionary = Dictionary<Shape, CAShapeLayer>()
    var shape = Shape.line
    var shapeLayer = CAShapeLayer()
    var lineWidth: Float = 5.0
    var opacity: Float = 0.2
    
    enum Shape {
        case line
        case rectangle
        case ellipse
        case freeLine
        case triangle
        case eraser
    }
    
    init() {
        if let data = model.getData(key: Constant.KEY_CASHAPELAYERS) {
            if let array = NSKeyedUnarchiver.unarchiveObject(with: data) as? Array<CAShapeLayer> {
                layers = array
            }
        }
    }
    
    func drawStraightLine(startPoint: CGPoint, translation: CGPoint) -> UIBezierPath {
        let bzPath = UIBezierPath()
        bzPath.move(to: startPoint)
        bzPath.addLine(to: CGPoint(x: startPoint.x + translation.x, y: startPoint.y + translation.y))
        return bzPath
    }
    
    func drawRectangle(startPoint: CGPoint, translation: CGPoint) -> UIBezierPath {
        return UIBezierPath(rect: CGRect(x:startPoint.x,
                                         y: startPoint.y,
                                         width: translation.x,
                                         height: translation.y))
    }
    
    func drawEllipse(startPoint: CGPoint, translation: CGPoint) -> UIBezierPath {
        return UIBezierPath(ovalIn:CGRect(x:startPoint.x,
                                          y: startPoint.y,
                                          width: translation.x,
                                          height: translation.y))
    }
    
    func drawNewLineTo(bzPath: UIBezierPath, startPoint: CGPoint, translation: CGPoint) -> UIBezierPath {
        let currentPoint = CGPoint(x: startPoint.x + translation.x, y: startPoint.y + translation.y)
        
        bzPath.addLine(to: currentPoint)
        bzPath.lineCapStyle = .round
        bzPath.lineJoinStyle = .round
        
        return bzPath
    }
    
    func drawTriangle(startPoint: CGPoint, translation: CGPoint) -> UIBezierPath {
        let bz = UIBezierPath()
        let vertexA = CGPoint(x: startPoint.x + (translation.x / 2), y: startPoint.y)
        let vertexB = CGPoint(x: startPoint.x, y: startPoint.y + translation.y)
        let vertexC = CGPoint(x: startPoint.x + translation.x, y: startPoint.y + translation.y)
        bz.move(to: vertexA)
        bz.addLine(to: vertexB)
        bz.addLine(to: vertexC)
        bz.close()
        return bz
    }
    
    func setupLayer() {
        shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.opacity = self.opacity
        shapeLayer.strokeColor = self.strokeColor.cgColor
        shapeLayer.lineWidth = CGFloat(self.lineWidth)
        shapeLayer.lineCap = "round"
        shapeLayer.lineJoin = "round"
        self.layers.append(shapeLayer)
    }
    
    func handlePan(_ sender: UIPanGestureRecognizer)
    {
        if sender.state == .began
        {
            startPoint = sender.location(in: sender.view)
            setupLayer()
            bzPath = UIBezierPath()
            bzPath?.move(to: startPoint)
        }
        else if sender.state == .changed
        {
            let translation = sender.translation(in: sender.view)
            
            switch shape {
            case .line:
                shapeLayer.path = drawStraightLine(startPoint: startPoint, translation: translation).cgPath
                break
            case .rectangle:
                shapeLayer.fillColor = self.fillColor.cgColor
                shapeLayer.path = drawRectangle(startPoint: startPoint, translation: translation).cgPath
                break
            case .ellipse:
                shapeLayer.fillColor = self.fillColor.cgColor
                shapeLayer.path = drawEllipse(startPoint: startPoint, translation: translation).cgPath
                break
            case .freeLine:
                if let bzp = bzPath {
                    let bz = drawNewLineTo(bzPath: bzp, startPoint: startPoint, translation: translation)
                    shapeLayer.path = bz.cgPath
                }
                break
            case .triangle:
                shapeLayer.fillColor = self.fillColor.cgColor
                shapeLayer.path = drawTriangle(startPoint: startPoint, translation: translation).cgPath
                break
            case .eraser:
                if let bzp = bzPath {
                    shapeLayer.strokeColor = UIColor.white.cgColor
                    shapeLayer.opacity = 1.0
                    let bz = drawNewLineTo(bzPath: bzp, startPoint: startPoint, translation: translation)
                    shapeLayer.path = bz.cgPath
                }
                break
            }
            
            updateLayersToView()
        } else {
            saveLayersToModel()
        }
    }
    
    func back() {
        if layers.count > 0 {
            self.layers.remove(at: self.layers.count - 1)
            updateLayersToView()
            saveLayersToModel()
        }
    }
    
    func removeAll() {
        if layers.count > 0 {
            self.layers.removeAll()
            updateLayersToView()
            saveLayersToModel()
        }
    }
    
    func updateLayersToView() {
        self.layerSubject.onNext(self.layers)
    }
    
    func saveLayersToModel() {
        model.setObjectAsData(key: Constant.KEY_CASHAPELAYERS, value: self.layers)
    }
}
