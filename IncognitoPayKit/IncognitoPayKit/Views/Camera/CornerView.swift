//
//  CornerView.swift
//  IncognitoPayKit
//
//  Created by Andreas Reuter on 28.11.20.
//

import UIKit

class CornerView: UIView {
  var lineWidth: CGFloat = 13
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    backgroundColor = UIColor.clear
  }
  
  override func draw(_ rect: CGRect) {
    let bezierPath = UIBezierPath()
    
    UIColor.white.set()
    
    bezierPath.lineWidth = lineWidth
    
    bezierPath.move(to: CGPoint(x: rect.minX, y: 0.1 * rect.maxY))
    bezierPath.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
    bezierPath.addLine(to: CGPoint(x: 30, y: rect.minY))
    bezierPath.stroke()
    
    bezierPath.move(to: CGPoint(x: rect.maxX - 0.1 * rect.maxX, y: rect.minY))
    bezierPath.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
    bezierPath.addLine(to: CGPoint(x: rect.maxX, y: 0.1 * rect.maxY))
    bezierPath.stroke()
    
    bezierPath.move(to: CGPoint(x: rect.maxX, y: rect.maxY - 0.1 * rect.maxY))
    bezierPath.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
    bezierPath.addLine(to: CGPoint(x: rect.maxX - 0.1 * rect.maxX, y: rect.maxY))
    bezierPath.stroke()
    
    bezierPath.move(to: CGPoint(x: rect.minX + 0.1 * rect.maxX, y: rect.maxY))
    bezierPath.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
    bezierPath.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - 0.1 * rect.maxY))
    bezierPath.stroke()
  }
}
