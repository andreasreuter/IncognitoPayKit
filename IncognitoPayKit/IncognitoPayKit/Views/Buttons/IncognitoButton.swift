//
//  IncognitoButton.swift
//  IncognitoPayKit
//
//  Created by Andreas Reuter on 24.11.20.
//  Copyright © 2020 NO DANCE MONKEY. All rights reserved.
//

import UIKit

class IncognitoButton: UIButton {
  var title: String
  
  private let cgSize: CGSize = CGSize(width: 100, height: 80)
  
  init(title: String) {
    self.title = title
    
    super.init(frame: CGRect.zero)
    
    /*
     * other function calls are available after super constructor
     * is called.
     */
    self.button()
    
    /*
     * activate event handlers.
     */
    self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override class func awakeFromNib() {
    super.awakeFromNib()
  }
  
  @objc final public func buttonTapped() {
    print("Incognito button tapped.")
  }
  
  private func button() {
    /*
     * design its normal button behaviour.
     */
    setTitle(self.title, for: .normal)
    setTitleColor(UIColor.white, for: .normal)
    titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
    backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0)
    layer.cornerRadius = 8
    
    /*
     * always set same button size for all button behaviours.
     */
    frame.size = cgSize
    
    titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
  }
}
