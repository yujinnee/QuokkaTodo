//
//  CircularProgressView.swift
//  QuokkaTodo
//
//  Created by 이유진 on 10/12/23.
//

import UIKit

class CircularProgressView: BaseView {
    var startAngle =  -90.degreesToRadians
    var progress: CGFloat = 0 {
        didSet {
            animateToBarLayer()
            if(oldValue == 0){
                setEndStatus()
            }
        }
    }
    var onePomoInterval:TimeInterval = 0
    var pauseStrokeEnd = 0.0
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    init(seconds:TimeInterval,onePomo: TimeInterval,frame:CGRect) {
        super.init(frame:frame)
        progress = seconds
        onePomoInterval = onePomo
        configureView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    private lazy var circularPath: UIBezierPath = {
        return UIBezierPath(arcCenter:  CGPoint(x: bounds.midX, y: bounds.midY),
                            radius: frame.size.width/2,
                            startAngle: -90.degreesToRadians, // 12시 방향 (0도가 3시방향)
                            endAngle: 270.degreesToRadians, // 2시 방향
                            clockwise: true)
    }()
    
    private lazy var trackLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.path = circularPath.cgPath
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = QColor.subLightColor.cgColor
        layer.lineWidth = 15
        layer.strokeEnd = 1
        return layer
    }()
    
    private lazy var barLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.path = circularPath.cgPath
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = QColor.accentColor.cgColor
        layer.lineWidth = 15
        layer.strokeEnd = 1
        return layer
    }()
       
    override func setConstraints() {
        layer.addSublayer(trackLayer)
        layer.addSublayer(barLayer)
    }
  
    func animateToBarLayer() {
        
        let strokeAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeAnimation.fromValue = progress
        strokeAnimation.toValue = progress-0.1/onePomoInterval
        strokeAnimation.duration = 0.1
    
        barLayer.add(strokeAnimation, forKey: nil)
        pauseStrokeEnd = progress-0.1/onePomoInterval
    }
    func setPauseStatus() {
        barLayer.strokeEnd = pauseStrokeEnd
    }
    func setEndStatus() {
        barLayer.strokeEnd = 0
    }
    func resetStatus() {
        barLayer.strokeEnd = 1
    }
}
