//
//  WalletPopoutButtons.swift
//  IncognitoPayKit
//
//  Created by Andreas Reuter on 17.03.2020.
//  Copyright © 2020 NO DANCE MONKEY. All rights reserved.
//

import UIKit

class WalletPopoutButtons: UIViewController {
  private(set) var base: UIViewController
  
  required init(base: UIViewController) {
    /*
     * wallet views cannot be overwritten, therefore it is mandatory
     * to gain access to the outer view controller eg to show them.
     */
    self.base = base
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override var previewActionItems: [UIPreviewActionItem] {
    return ([
      /*
       * backup the wallet keys.
       */
      UIPreviewAction(title: "Backup", style: .default, handler: { (_, _) in })
    ])
  }
}

@available(iOS 13.0, *)
extension IncognitoPayButton {
  public override func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
    let previewOptions = UIContextMenuConfiguration(
      identifier: nil,
      previewProvider: nil) { _ in
      /*
       * receive money via QR Code from a friend.
       */
      let qrCode = UIAction(title: "Show my QR Code", image: UIImage(systemName: "qrcode"), handler: self.qrCodeButtonTapped)
      
      /*
       * backup the wallet keys.
       */
      let backupWallet = UIAction(title: "Backup", image: UIImage(systemName: "doc.on.doc"), identifier: nil, handler: self.backupButtonTapped)
      
      let children = [qrCode, backupWallet]
      return (UIMenu(title: "", children: children))
    }
    
    return (previewOptions)
  }
  
  func walletPreview() -> UIViewController? {
    let uiView = UIViewController()
    uiView.preferredContentSize = CGSize(width: 300, height: 400)
    return (uiView)
  }
  
  @objc final public func qrCodeButtonTapped(_ sender: UIAction) {
    print("Incognito Pay receive coin via QR Code button tapped.")
    
    do {
      let keychain = WalletDataKeychain()
      let walletData = try keychain.read()
      
      let walletQRCode = WalletQRCodeView(base: self.base, codeValue: walletData.walletAddress)
      walletQRCode.modalPresentationStyle = .popover
      
      self.base.present(walletQRCode, animated: true)
    } catch {
      print("Error read wallet from Keychain: \(error).")
      
      let errorAlert = UIAlertController.errorAlert(
        title: "Wallet error",
        message: "Cannot read your wallet. Try again!"
      )
      self.base.present(errorAlert, animated: true)
    }
  }
  
  @objc final public func backupButtonTapped(_ sender: UIAction) {
    print("Incognito backup wallet button tapped.")
    
    do {
      let keychain = WalletDataKeychain()
      let walletData = try keychain.read()
      
      let pasteboard = UIPasteboard.general
      pasteboard.string = walletData.description
      
      let activityAlert = UIAlertController.activityAlert(
        symbolName: "checkmark.circle.fill",
        text: "Copied!"
      )
      self.base.present(activityAlert, animated: true)
      
      DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.8) {
        activityAlert.dismiss(animated: true) {
          self.base.dismiss(animated: true)
        }
      }
    } catch {
      print("Error backup wallet from Keychain: \(error).")
      
      let errorAlert = UIAlertController.errorAlert(
        title: "Backup error",
        message: "Cannot backup your wallet. Try again!"
      )
      self.base.present(errorAlert, animated: true)
    }
  }
}
