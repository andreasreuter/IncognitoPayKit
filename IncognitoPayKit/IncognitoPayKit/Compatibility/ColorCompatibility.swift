//
//  ColorCompatibility.swift
//  IncognitoPayKit
//
//  Created by Andreas Reuter on 22.01.21.
//  Copyright © 2020 NO DANCE MONKEY. All rights reserved.
//

import SwiftUI

enum ColorCompatibility {
  static var label: UIColor {
    if #available(iOS 13.0, *) {
      return (.label)
    }
    
    // Fallback on earlier versions
    if #available(iOS 12.0, *) {
      return (
        UIScreen.main.traitCollection.userInterfaceStyle == .light
          ? UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
          : UIColor(red: 255.0, green: 255.0, blue: 255.0, alpha: 1.0)
      )
    } else {
      return (UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0))
    }
  }
  
  static var systemBackground: UIColor {
    if #available(iOS 13.0, *) {
      return (.systemBackground)
    }
    
    // Fallback on earlier versions
    if #available(iOS 12.0, *) {
      return (
        UIScreen.main.traitCollection.userInterfaceStyle == .light
          ? UIColor(red: 255.0, green: 255.0, blue: 255.0, alpha: 1.0)
          : UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
      )
    } else {
      return (UIColor(red: 255.0, green: 255.0, blue: 255.0, alpha: 1.0))
    }
  }
  
  static var secondarySystemBackground: UIColor {
    if #available(iOS 13.0, *) {
      return (.secondarySystemBackground)
    }
    
    // Fallback on earlier versions
    if #available(iOS 12.0, *) {
      return (
        UIScreen.main.traitCollection.userInterfaceStyle == .light
          ? UIColor(red: 242.0, green: 242.0, blue: 247.0, alpha: 1.0)
          : UIColor(red: 28.0, green: 28.0, blue: 30.0, alpha: 1.0)
      )
    } else {
      return (UIColor(red: 242.0, green: 242.0, blue: 247.0, alpha: 1.0))
    }
  }
}
