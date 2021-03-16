//
//  WalletQRCodeView.swift
//  IncognitoPayKit
//
//  Created by Andreas Reuter on 23.11.20.
//  Copyright © 2020 NO DANCE MONKEY. All rights reserved.
//

import UIKit

class WalletQRCodeView: UIViewController {
  private(set) var base: UIViewController
  
  private(set) var codeValue: String
  
  required init(base: UIViewController, codeValue: String) {
    /*
     * wallet views cannot be overwritten, therefore it is mandatory
     * to gain access to the outer view controller eg to show them.
     */
    self.base = base
    self.codeValue = codeValue
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  fileprivate let stackView: UIStackView = {
    let stack = UIStackView()
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.axis = .vertical
    stack.spacing = 40
    return (stack)
  }()
  
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
  
  fileprivate let copyButton: UIButton = {
    let button = IncognitoButton(title: "Copy my wallet address")
    button.translatesAutoresizingMaskIntoConstraints = false
    return (button)
  }()
  
  /*
   * generate QR Code from wallet's public address.
   */
  final fileprivate var walletQRCode: UIImageView {
    let walletQRCode = UIImageView(
      image: WalletQRCode.transform(from: codeValue, scaleX: 10, scaleY: 10)
    )
    walletQRCode.contentMode = .center
    walletQRCode.translatesAutoresizingMaskIntoConstraints = false
    return (walletQRCode)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = ColorCompatibility.systemBackground
    
    /*
     * Cannot add button targets in initial function because at this time
     * the handler isn't available.
     */
    closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    copyButton.addTarget(self, action: #selector(copyButtonTapped), for: .touchUpInside)
    
    stackView.addArrangedSubview(walletQRCode)
    stackView.addArrangedSubview(copyButton)
    
    view.addSubview(closeButton)
    view.addSubview(stackView)
    
    NSLayoutConstraint.activate([
      copyButton.heightAnchor.constraint(equalToConstant: 70),
      copyButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
      copyButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
      
      closeButton.topAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.topAnchor,
        constant: 20
      ),
      closeButton.leadingAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.leadingAnchor,
        constant: 20
      ),
      
      stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
    ])
  }
  
  @objc final public func closeButtonTapped() {
    print("Incognito Pay close button tapped.")
    self.dismiss(animated: true)
  }
  
  @objc final public func copyButtonTapped(_ sender: UIButton) {
    print("Incognito copy address button tapped.")
    let pasteboard = UIPasteboard.general
    pasteboard.string = codeValue
    
    let activityAlert = UIAlertController.activityAlert(
      symbolName: "checkmark.circle.fill",
      text: "Copied!"
    )
    self.present(activityAlert, animated: true)
    
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.8) {
      activityAlert.dismiss(animated: true) {
        self.dismiss(animated: true)
      }
    }
  }
}
