//
//  UIAlertController+Activity.swift
//  IncognitoPayKit
//
//  Created by Andreas Reuter on 26.12.20.
//  Copyright © 2020 NO DANCE MONKEY. All rights reserved.
//

import UIKit

extension UIAlertController {
  func addActivity(symbolName: String, text: String) {
    let image = UIImage(
      systemName: symbolName,
      withConfiguration: UIImage.SymbolConfiguration(pointSize: 110)
    )
    
    let imageView = UIImageView(image: image)
    imageView.tintColor = (traitCollection.userInterfaceStyle == .light ? .black : .white)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
    label.text = text
    label.textColor = (traitCollection.userInterfaceStyle == .light ? .black : .white)
    label.translatesAutoresizingMaskIntoConstraints = false
    
    let alertWidth = view.bounds.width / 1.5
    
    view.addSubview(imageView)
    view.addSubview(label)
    
    view.clipsToBounds = true
    
    NSLayoutConstraint.activate([
      imageView.centerYAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.centerYAnchor,
        constant: -20
      ),
      imageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
      
      label.centerYAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.centerYAnchor,
        constant: 70
      ),
      label.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
      
      view.heightAnchor.constraint(equalToConstant: alertWidth),
      view.widthAnchor.constraint(equalToConstant: alertWidth)
    ])
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
}
