//
//  IncognitoPayButtonActions.swift
//  IncognitoPayKit
//
//  Created by Andreas Reuter on 23.11.20.
//  Copyright © 2020 NO DANCE MONKEY. All rights reserved.
//

import UIKit

class IncognitoPayButtonActions: UIAlertController {
  override var preferredStyle: UIAlertController.Style {
    get {
      return (.actionSheet)
    }
  }
  
  init() {
    super.init(nibName: nil, bundle: nil)
    
    /*
     * other function calls are available after super constructor
     * is called.
     */
    self.title = nil
    self.message = nil
    
    self.options()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override class func awakeFromNib() {
    super.awakeFromNib()
  }
  
  private func options() {
    /*
     * import an existing wallet.
     */
    let importWallet = formatOption(title: "Import my wallet", style: .default)
    addAction(importWallet)
    
    /*
     * send money to a friend, etc.
     */
    let sendTo = formatOption(title: "Send to...", style: .default)
    addAction(sendTo)
    
    /*
     * receive money from a friend.
     */
    let receive = formatOption(title: "Receive", style: .default)
    addAction(receive)
    
    /*
     * cancel button closes action sheet.
     */
    let cancel = formatOption(title: "Cancel", style: .cancel)
    addAction(cancel)
    
  }
  
  private func formatOption(title: String, style: UIAlertAction.Style) -> UIAlertAction {
    UIAlertAction(
      title: title,
      style: style
    )
  }
}
