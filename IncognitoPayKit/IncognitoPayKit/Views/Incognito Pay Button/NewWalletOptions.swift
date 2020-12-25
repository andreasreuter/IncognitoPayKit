//
//  NewWalletOptions.swift
//  IncognitoPayKit
//
//  Created by Andreas Reuter on 25.12.20.
//  Copyright © 2020 NO DANCE MONKEY. All rights reserved.
//

import UIKit

class NewWalletOptions: UIAlertController {
  override var preferredStyle: UIAlertController.Style {
    get {
      return (.actionSheet)
    }
  }
  
  var newWallet: () -> Void
  
  var importWallet: () -> Void
  
  init(newWallet: @escaping () -> Void, importWallet: @escaping () -> Void) {
    self.newWallet = newWallet
    self.importWallet = importWallet
    
    super.init(nibName: nil, bundle: nil)
    
    /*
     * other function calls are available after super constructor
     * is called.
     */
    self.title = "Pay with Crypto privately. Powered by Incognito."
    self.message = "Before you can pay the first time. You must either create a new wallet or import a wallet."
    
    self.options()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func options() {
    /*
     * create a new wallet.
     */
    let newWallet = formatOption(title: "New wallet", style: .default, self.newWallet)
    addAction(newWallet)
    
    /*
     * import an existing wallet.
     */
    let importWallet = formatOption(title: "Import my wallet", style: .default, self.importWallet)
    addAction(importWallet)
    
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
