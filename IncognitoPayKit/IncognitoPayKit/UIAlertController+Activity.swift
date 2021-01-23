//
//  UIAlertController+Activity.swift
//  IncognitoPayKit
//
//  Created by Andreas Reuter on 26.12.20.
//  Copyright © 2020 NO DANCE MONKEY. All rights reserved.
//

import UIKit

extension UIAlertController {
  func addActivity(_ uiView: UIView, text: String) {
    uiView.translatesAutoresizingMaskIntoConstraints = false
    
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
    label.text = text
    label.textColor = ColorCompatibility.label
    label.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(uiView)
    view.addSubview(label)
    
    view.clipsToBounds = true
    
    let alertWidth = view.bounds.width / 1.5
    
    NSLayoutConstraint.activate([
      uiView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
      uiView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      
      label.centerYAnchor.constraint(
        equalTo: view.centerYAnchor,
        constant: 70
      ),
      label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      
      view.heightAnchor.constraint(equalToConstant: alertWidth),
      view.widthAnchor.constraint(equalToConstant: alertWidth)
    ])
  }
  
  func addActivity(symbolName: String, text: String) {
    let image: UIImage?
    if #available(iOS 13.0, *) {
      image = UIImage(
        systemName: symbolName,
        withConfiguration: UIImage.SymbolConfiguration(pointSize: 110)
      )
    } else {
      // Fallback on earlier versions
      image = UIImage(named: symbolName)
    }
    
    let imageView = UIImageView(image: image)
    imageView.tintColor = ColorCompatibility.label
    imageView.translatesAutoresizingMaskIntoConstraints = false
    
    self.addActivity(imageView, text: text)
  }
  
  static func activityAlert(symbolName: String, text: String) -> UIAlertController {
    let activityAlert = UIAlertController(
      title: "",
      message: "",
      preferredStyle: .alert
    )
    activityAlert.addActivity(symbolName: symbolName, text: text)
    return (activityAlert)
  }
  
  static func loadingAlert(text: String) -> UIAlertController {
    let activityIndicatorView = ActivityIndicatorView()
    
    let activityAlert = UIAlertController(
      title: "",
      message: "",
      preferredStyle: .alert
    )
    activityAlert.addActivity(activityIndicatorView, text: text)
    return (activityAlert)
  }
}
