//
//  ProgressView.swift
//  CustomProgressBar
//
//  Created by Sztanyi Szabolcs on 16/10/14.
//  Copyright (c) 2014 Sztanyi Szabolcs. All rights reserved.
//

import UIKit

class ProgressView: UIView {

    // the layer that shows the actual progress
    private let progressLayer: CAShapeLayer = CAShapeLayer()
    
    private var progressLabel: UILabel = UILabel()
    private var sizeProgressLabel : UILabel = UILabel()
    
    // layer to show the dashed circle layer
    private var dashedLayer: CAShapeLayer = CAShapeLayer()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = UIColor.clearColor()
        //createProgressLayer()
        createLabel()
    }
    
    func createLabel() {
        
        progressLabel = UILabel()
        progressLabel.textColor = UIColor.blackColor()
        progressLabel.textAlignment = .Center
        progressLabel.text = "0 %"
        progressLabel.font = UIFont(name: "HelveticaNeue-UltraLight", size: 40.0)
        progressLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        addSubview(progressLabel)
        // add constraints
        addConstraint(NSLayoutConstraint(item: self, attribute: .CenterX, relatedBy: .Equal, toItem: progressLabel, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: self, attribute: .CenterY, relatedBy: .Equal, toItem: progressLabel, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
        
        // label to show the already downloaded size and the total size of the file
        sizeProgressLabel = UILabel()
        sizeProgressLabel.textColor = .blackColor()
        sizeProgressLabel.textAlignment = .Center
        sizeProgressLabel.text = "0.0 MB / 0.0 MB"
        sizeProgressLabel.font = UIFont(name: "HelveticaNeue-Light", size: 10.0)
        sizeProgressLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        addSubview(sizeProgressLabel)
        // add constraints
        addConstraint(NSLayoutConstraint(item: self, attribute: .CenterX, relatedBy: .Equal, toItem: sizeProgressLabel, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: progressLabel, attribute: .Bottom, relatedBy: .Equal, toItem: sizeProgressLabel, attribute: .Top, multiplier: 1.0, constant: -10.0))
    }
    
    private func createProgressLayer() {
        let startAngle = CGFloat(M_PI_2)
        let endAngle = CGFloat(M_PI * 2 + M_PI_2)
        
        
        let centerPoint = CGPointMake(CGRectGetWidth(frame)/2 , CGRectGetHeight(frame)/2)
        println(centerPoint)
        
        
        progressLayer.path = UIBezierPath(arcCenter:centerPoint, radius: CGRectGetWidth(frame)/2 - 10.0, startAngle:startAngle, endAngle:endAngle, clockwise: true).CGPath
        progressLayer.backgroundColor = UIColor.clearColor().CGColor
        progressLayer.fillColor = nil
        progressLayer.strokeColor = UIColor.blackColor().CGColor
        progressLayer.lineWidth = 4.0
        progressLayer.strokeStart = 0.0
        progressLayer.strokeEnd = 0.0
        layer.addSublayer(progressLayer)
        
        var dashedLayer = CAShapeLayer()
        dashedLayer.strokeColor = UIColor.blackColor().CGColor
        dashedLayer.fillColor = nil
        dashedLayer.lineDashPattern = [2, 4]
        dashedLayer.lineJoin = "round"
        dashedLayer.lineWidth = 2.0
        dashedLayer.path = progressLayer.path
        layer.insertSublayer(dashedLayer, below: progressLayer)
    }
    
    func animateProgressViewToProgress(progress: Float) {
//        let animation = CABasicAnimation(keyPath: "strokeEnd")
//        animation.fromValue = CGFloat(progressLayer.strokeEnd)
//        animation.toValue = CGFloat(progress)
//        animation.duration = 0.2
//        animation.fillMode = kCAFillModeForwards
//        progressLayer.strokeEnd = CGFloat(progress)
//        progressLayer.addAnimation(animation, forKey: "animation")
    }
    
    func updateProgressViewLabelWithProgress(percent: Float) {
        progressLabel.text = NSString(format: "%.0f %@", percent, "%") as String
    }
    
    func updateProgressViewWith(totalSent: Float, totalFileSize: Float) {
        sizeProgressLabel.text = NSString(format: "%.1f MB / %.1f MB", convertFileSizeToMegabyte(totalSent), convertFileSizeToMegabyte(totalFileSize)) as String
    }
    
    private func convertFileSizeToMegabyte(size: Float) -> Float {
        return (size / 1024) / 1024
    }
    
    func hideProgressView() {
        progressLayer.strokeEnd = 0.0
        progressLayer.removeAllAnimations()
    }
    
    override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
        hideProgressView()
    }
}
