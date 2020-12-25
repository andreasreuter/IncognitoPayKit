//
//  UIView+BlurView.swift
//  IncognitoPayKit
//
//  Created by Andreas Reuter on 25.12.20.
//

import UIKit

extension UIView {
  func blurView(alwaysLight: Bool = false) {
    /*
     * only apply the blur if the user hasn't
     * disabled transparency effects.
     */
    if !UIAccessibility.isReduceTransparencyEnabled {
      backgroundColor = .clear
      
      var blurEffect = UIBlurEffect(style: .systemChromeMaterialLight)
      if (alwaysLight == false && traitCollection.userInterfaceStyle == .dark) {
        blurEffect = UIBlurEffect(style: .systemChromeMaterialDark)
      }
      
      let blurEffectView = UIVisualEffectView(effect: blurEffect)
      
      // always fill the view.
      blurEffectView.frame = bounds
      blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
      blurEffectView.isUserInteractionEnabled = false

      addSubview(blurEffectView)
      sendSubviewToBack(blurEffectView)
    } else {
      // otherwise fill with background color.
      backgroundColor = .systemBackground
    }
  }
}
