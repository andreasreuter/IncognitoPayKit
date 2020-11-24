//
//  WalletQRCode.swift
//  IncognitoPayKit
//
//  Created by Andreas Reuter on 23.11.20.
//  Copyright © 2020 NO DANCE MONKEY. All rights reserved.
//

import UIKit

class WalletQRCode {
  static func transform(from value: String, scaleX: CGFloat, scaleY: CGFloat) -> UIImage? {
    let data = value.data(using: String.Encoding.ascii)
    
    if let ciFilter = CIFilter(name: "CIQRCodeGenerator") {
      ciFilter.setValue(data, forKey: "inputMessage")
      let transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
      
      if let output = ciFilter.outputImage?.transformed(by: transform) {
        return UIImage(ciImage: output)
      }
    }
    
    return (nil)
  }
}
