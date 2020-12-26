//
//  UIAlertController+Error.swift
//  IncognitoPayKit
//
//  Created by Andreas Reuter on 26.12.20.
//  Copyright © 2020 NO DANCE MONKEY. All rights reserved.
//

import UIKit

extension UIAlertController {
  static func errorAlert(title: String, message: String) -> UIAlertController {
    let errorAlert = UIAlertController(
      title: title,
      message: message,
      preferredStyle: .alert
    )
    errorAlert.addAction(
      UIAlertAction(title: "OK", style: .default) { action in
        switch action.style {
        case .default:
          print("Error alert close button tapped.")
        default:
          print("Error alert unknown button tapped.")
        }
      }
    )
    return (errorAlert)
  }
}
