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
    let xmark = UIImage(
      systemName: "xmark",
      withConfiguration: UIImage.SymbolConfiguration(scale: .large)
    )
    button.setImage(xmark, for: .normal)
    button.tintColor = (traitCollection.userInterfaceStyle == .light ? .black : .white)
    button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    return (button)
  }()
  
  fileprivate let copyButton: UIButton = {
    let button = IncognitoButton(title: "Copy my wallet address")
    button.addTarget(self, action: #selector(copyButtonTapped), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    return (button)
  }()
  
  fileprivate lazy var copiedImage: UIImageView = {
    let checkmark = UIImage(
      systemName: "checkmark.circle.fill",
      withConfiguration: UIImage.SymbolConfiguration(pointSize: 110)
    )
    
    let imageView = UIImageView(image: checkmark)
    imageView.tintColor = (traitCollection.userInterfaceStyle == .light ? .black : .white)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return (imageView)
  }()
  
  fileprivate lazy var copiedText: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
    label.text = "Copied!"
    label.textColor = (traitCollection.userInterfaceStyle == .light ? .black : .white)
    label.translatesAutoresizingMaskIntoConstraints = false
    return (label)
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
    
    view.backgroundColor = (traitCollection.userInterfaceStyle == .light ? .white : .black)
    
    stackView.addArrangedSubview(walletQRCode)
    stackView.addArrangedSubview(copyButton)
    
    view.addSubview(closeButton)
    view.addSubview(stackView)
    
    NSLayoutConstraint.activate([
      copyButton.heightAnchor.constraint(equalToConstant: 70),
      copyButton.leadingAnchor.constraint(equalTo: stackView.layoutMarginsGuide.leadingAnchor),
      copyButton.trailingAnchor.constraint(equalTo: stackView.layoutMarginsGuide.trailingAnchor),
      
      closeButton.topAnchor.constraint(
        equalTo: view.layoutMarginsGuide.topAnchor,
        constant: 20
      ),
      closeButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
      
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
    
    let alert = confirmWhenCopied()
    self.present(alert, animated: true)
    
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.8) {
      alert.dismiss(animated: true) {
        self.dismiss(animated: true)
      }
    }
  }
  
  private func confirmWhenCopied() -> UIAlertController {
    let alert = UIAlertController(title: "", message: nil, preferredStyle: .alert)
    alert.view.addSubview(copiedImage)
    alert.view.addSubview(copiedText)
    
    let alertWidth = view.bounds.width / 1.5
    
    NSLayoutConstraint.activate([
      copiedImage.topAnchor.constraint(
        equalTo: alert.view.safeAreaLayoutGuide.topAnchor,
        constant: 50
      ),
      copiedImage.centerXAnchor.constraint(equalTo: alert.view.safeAreaLayoutGuide.centerXAnchor),
      
      copiedText.topAnchor.constraint(
        equalTo: copiedImage.safeAreaLayoutGuide.bottomAnchor,
        constant: 15
      ),
      copiedText.centerXAnchor.constraint(equalTo: alert.view.safeAreaLayoutGuide.centerXAnchor),
      
      alert.view.heightAnchor.constraint(equalToConstant: alertWidth),
      alert.view.widthAnchor.constraint(equalToConstant: alertWidth)
    ])
    
    return (alert)
  }
}
