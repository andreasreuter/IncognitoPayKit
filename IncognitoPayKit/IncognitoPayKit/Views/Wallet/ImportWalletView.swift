//
//  ImportWalletView.swift
//  IncognitoPayKit
//
//  Created by Andreas Reuter on 27.12.20.
//  Copyright © 2020 NO DANCE MONKEY. All rights reserved.
//

import UIKit

class ImportWalletView: UIViewController, UITextViewDelegate {
  private let id: String
  
  public init(id: String) {
    self.id = id
    
    super.init(nibName: nil, bundle: nil)
  }
  
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  fileprivate lazy var closeButton: UIButton = {
    let button = UIButton()
    let xmark: UIImage?
    
    if #available(iOS 13.0, *) {
      xmark = UIImage(
        systemName: "xmark",
        withConfiguration: UIImage.SymbolConfiguration(scale: .large)
      )
      
    } else {
      // Fallback on earlier versions
      xmark = UIImage(named: "xmark")
    }
    
    button.setImage(xmark, for: .normal)
    button.tintColor = ColorCompatibility.label
    button.translatesAutoresizingMaskIntoConstraints = false
    return (button)
  }()
  
  fileprivate lazy var importText: UITextView = {
    let toolbar = UIToolbar()
    toolbar.sizeToFit()
    
    let importButton = UIBarButtonItem(
      title: "Import wallet",
      style: .done,
      target: self,
      action: #selector(importButtonTapped)
    )
    toolbar.items = [importButton]
    
    let textView = UITextView()
    textView.font = UIFont.systemFont(ofSize: 42, weight: .semibold)
    textView.text = "Enter your private key..."
    textView.textAlignment = .left
    textView.backgroundColor = ColorCompatibility.systemBackground
    textView.autocorrectionType = .no
    textView.delegate = self
    textView.inputAccessoryView = toolbar
    textView.translatesAutoresizingMaskIntoConstraints = false
    return (textView)
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = ColorCompatibility.systemBackground
    
    /*
     * Cannot add button targets in initial function because at this time
     * the handler isn't available.
     */
    closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    
    view.addSubview(closeButton)
    view.addSubview(importText)
    
    NSLayoutConstraint.activate([
      closeButton.topAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.topAnchor,
        constant: 20
      ),
      closeButton.leadingAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.leadingAnchor,
        constant: 20
      ),
      
      importText.leadingAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.leadingAnchor,
        constant: 20
      ),
      importText.trailingAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.trailingAnchor,
        constant: -20
      ),
      importText.topAnchor.constraint(
        equalTo: closeButton.bottomAnchor,
        constant: 20
      ),
      importText.bottomAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.bottomAnchor,
        constant: -20
      ),
      importText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
    ])
  }
  
  @objc final public func closeButtonTapped() {
    print("Incognito Pay close button tapped.")
    self.dismiss(animated: true)
  }
  
  @objc final public func importButtonTapped() {
    print("Incognito Pay import wallet button tapped.")
    
    let loadingAlert = UIAlertController.loadingAlert(
      text: "Importing wallet..."
    )
    self.present(loadingAlert, animated: true)
    
    do {
      try NewWallet.importWallet(privateKey: importText.text!, id: id) { wallet in
        do {
          guard let _ = wallet else {
            throw WalletError.nilWallet
          }
          
          try WalletData.storeWallet(wallet: wallet!)
          
          DispatchQueue.main.async {
            loadingAlert.dismiss(animated: true) {
              let activityAlert = UIAlertController.activityAlert(
                symbolName: "rectangle.fill.badge.plus",
                text: "Wallet imported!"
              )
              self.present(activityAlert, animated: true)
              
              DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.4) {
                activityAlert.dismiss(animated: true) {
                  self.dismiss(animated: true)
                }
              }
            }
          }
        } catch is WalletError {
          print("Error create wallet via backend.")
          
          DispatchQueue.main.async {
            loadingAlert.dismiss(animated: true) {
              let errorAlert = UIAlertController.errorAlert(
                title: "Temporary error",
                message: "Cannot import wallet. Try again!"
              )
              self.present(errorAlert, animated: true)
            }
          }
        } catch {
          print("Error store wallet in Keychain: \(error).")
          
          DispatchQueue.main.async {
            loadingAlert.dismiss(animated: true) {
              let errorAlert = UIAlertController.errorAlert(
                title: "Temporary error",
                message: "Cannot store wallet in Keychain. Try again!"
              )
              self.present(errorAlert, animated: true)
            }
          }
        }
      }
    } catch {
      print("Error import wallet via backend: \(error).")
      
      DispatchQueue.main.async {
        loadingAlert.dismiss(animated: true) {
          let errorAlert = UIAlertController.errorAlert(
            title: "Temporary error",
            message: "Cannot import wallet. Try again!"
          )
          self.present(errorAlert, animated: true)
        }
      }
    }
  }
}
