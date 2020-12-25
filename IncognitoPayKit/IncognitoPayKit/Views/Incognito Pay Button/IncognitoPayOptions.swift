//
//  IncognitoPayOptions.swift
//  IncognitoPayKit
//
//  Created by Andreas Reuter on 23.11.20.
//  Copyright © 2020 NO DANCE MONKEY. All rights reserved.
//

import UIKit

class IncognitoPayOptions: UIAlertController {
  override var preferredStyle: UIAlertController.Style {
    get {
      return (.actionSheet)
    }
  }
  
  var sendTo: () -> Void
  
  var receive: () -> Void
  
  init(sendTo: @escaping () -> Void, receive: @escaping () -> Void) {
    self.sendTo = sendTo
    self.receive = receive
    
    super.init(nibName: nil, bundle: nil)
    
    /*
     * other function calls are available after super constructor
     * is called.
     */
    self.title = "Pay with Crypto privately. Powered by Incognito."
    self.message = nil
    
    self.options()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func options() {
    /*
     * send money to a friend, etc.
     */
    let sendTo = formatOption(title: "Send to...", style: .default, self.sendTo)
    addAction(sendTo)
    
    /*
     * receive money from a friend.
     */
    let receive = formatOption(title: "Receive", style: .default, self.receive)
    addAction(receive)
    
    /*
     * cancel button closes action sheet.
     */
    let cancel = formatOption(title: "Cancel", style: .cancel, nil)
    addAction(cancel)
  }
  
  private func formatOption(title: String, style: UIAlertAction.Style, _ handler: (() -> Void)?) -> UIAlertAction {
    UIAlertAction(
      title: title,
      style: style,
      handler: { _ in
        handler?()
      }
    )
  }
}
