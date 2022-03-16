//
//  CircularProgressView.swift
//  Songs
//
//  Created by Dushyant Singh on 16/3/22.
//

import UIKit
class CircularProgressView: UIView {
    // First create two layer properties
    private var backgroundLayer = CAShapeLayer()
    private var progressLayer = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    func setProgress(_ progress: Float) {
        let startPoint = CGPoint(x: frame.size.width / 2.0,
                                 y: frame.size.height / 2.0)
        let circularPath2 = UIBezierPath(arcCenter: startPoint,
                                        radius: frame.size.width/3,
                                        startAngle:.initialAngle,
                                         endAngle: .endAngle(progress: CGFloat(progress)),
                                        clockwise: true)
        progressLayer.path = circularPath2.cgPath
    }
}

private extension CircularProgressView {
    func setupUI() {
        self.backgroundColor = UIColor.clear
        let startPoint = CGPoint(x: frame.size.width / 2.0,
                                 y: frame.size.height / 2.0)
        let circularPath = UIBezierPath(arcCenter: startPoint,
                                        radius: frame.size.width/3,
                                        startAngle:.initialAngle,
                                        endAngle: .endAngle(progress: 1),
                                        clockwise: true)

        backgroundLayer.path = circularPath.cgPath
        backgroundLayer.fillColor = UIColor.clear.cgColor
        backgroundLayer.lineCap = .round
        backgroundLayer.lineWidth = 2.0
        backgroundLayer.strokeColor = UIColor.white.cgColor

        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.lineWidth = 2.0
        progressLayer.strokeColor = UIColor.red.cgColor
        layer.addSublayer(backgroundLayer)
        layer.addSublayer(progressLayer)
    }
}

private extension CGFloat {
    static var initialAngle: CGFloat = -(.pi / 2)

    static func endAngle(progress: CGFloat) -> CGFloat {
        .pi * 2 * progress + .initialAngle
    }
}
