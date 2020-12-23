//
//  InsetLabel.swift
//  IncognitoPayKit
//
//  Created by Andreas Reuter on 23.12.20.
//

import UIKit

class InsetLabel: UILabel {
  var topInset: CGFloat = 0.0
  var leftInset: CGFloat = 0.0
  var bottomInset: CGFloat = 0.0
  var rightInset: CGFloat = 0.0
  
  var insets: UIEdgeInsets {
    get {
      return (UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset))
    }
    set {
      topInset = newValue.top
      leftInset = newValue.left
      bottomInset = newValue.bottom
      rightInset = newValue.right
    }
  }
  
  override func drawText(in rect: CGRect) {
    super.drawText(in: rect.inset(by: insets))
  }
  
  override func sizeThatFits(_ size: CGSize) -> CGSize {
    var adjustSize = super.sizeThatFits(size)
    adjustSize.width += leftInset + rightInset
    adjustSize.height += topInset + bottomInset
    
    return (adjustSize)
  }
  
  override var intrinsicContentSize: CGSize {
    var contentSize = super.intrinsicContentSize
    contentSize.width += leftInset + rightInset
    contentSize.height += topInset + bottomInset
    
    return contentSize
  }
}
