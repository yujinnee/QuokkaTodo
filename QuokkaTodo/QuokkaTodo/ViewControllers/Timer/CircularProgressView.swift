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
    init(seconds:TimeInterval,onePomo: TimeInterval) {
        super.init(frame: .zero)
        progress = seconds
        onePomoInterval = onePomo
        configureView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private lazy var circularPath: UIBezierPath = {
        return UIBezierPath(arcCenter: CGPoint(x: bounds.midX+155, y: bounds.midY+155),
                            radius: 140, // 반지름
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
        return layer
    }()
    
    private lazy var barLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.path = circularPath.cgPath
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = QColor.accentColor.cgColor
        layer.lineWidth = 15
        return layer
    }()
    override func configureView() {
        //        print(frame)
        //        print(bounds)
        //        circularPath=UIBezierPath(arcCenter: CGPoint(x: frame.width/2, y: frame.height/2),
        //                            radius: 140, // 반지름
        //                            startAngle: startAngle, // 12시 방향 (0도가 3시방향)
        //                            endAngle: 270.degreesToRadians,
        //                            clockwise: true)
    }
    override func setConstraints() {
        layer.addSublayer(trackLayer)
        layer.addSublayer(barLayer)
    }
    override func draw(_ rect: CGRect) {
        // 원의 경로 생성
//        print(#function)
        //        let circlePath = UIBezierPath(ovalIn: rect)
        // 원 내부 채우기 색상
        //        UIColor.lightGray.setFill()
        //        circlePath.fill()
        //
        //        circlePath.fillColor = UIColor.clear.cgColor
        //        circlePath.strokeColor = QColor.subLightColor.cgColor
        //        circlePath.lineWidth = 15
        //
        // 원형 프로그레스바 그리기
        //        let center = CGPoint(x: rect.midX, y: rect.midY)
        //        let radius = min(rect.width, rect.height) / 2 * 0.8
        //        let startAngle = -CGFloat.pi / 2 // 12시 방향부터 시작
        //        let endAngle = startAngle + progress * 2 * CGFloat.pi // 프로그레스 비율에 따라 끝 각도 결정
        //        let progressPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        //        progressPath.lineWidth = 10
        //        UIColor.blue.setStroke()
        //        progressPath.stroke()
        
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
