//
//  PaymentConfirmView.swift
//  IncognitoPayKit
//
//  Created by Andreas Reuter on 23.12.20.
//  Copyright © 2020 NO DANCE MONKEY. All rights reserved.
//

import UIKit

class PaymentConfirmView: UIViewController {
  private(set) var base: UIViewController
  
  private var contact: Contact
  
  private var amount: String
  
  required init(base: UIViewController, contact: Contact, amount: String) {
    /*
     * payment view cannot be overwritten, therefore it is mandatory
     * to gain access to the outer view controller eg to show them.
     */
    self.base = base
    self.contact = contact
    self.amount = amount
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  fileprivate lazy var closeButton: UIButton = {
    let button = UIButton()
    button.setTitle("Cancel", for: .normal)
    button.setTitleColor(
      (traitCollection.userInterfaceStyle == .light ? .black : .white),
      for: .normal
    )
    button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    return (button)
  }()
  
  fileprivate lazy var image: UIImageView = {
    let bundle = Bundle(for: ContactTableCell.self)
    
    let image = UIImage(
      named: contact.image ?? "",
      in: bundle,
      compatibleWith: nil
    )
    
    let imageView = UIImageView(image: image)
    imageView.contentMode = .scaleAspectFill
    imageView.layer.cornerRadius = 40
    imageView.layer.masksToBounds = true
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return (imageView)
  }()
  
  fileprivate lazy var titleLabel: UILabel = {
    let label = UILabel(frame: .zero)
    label.text = "\(contact.firstName) \(contact.lastName)"
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    return (label)
  }()
  
  fileprivate lazy var amountLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 70, weight: .medium)
    label.text = amount
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    return (label)
  }()
  
  fileprivate let currencyButton: UIButton = {
    let button = IncognitoButton(title: "PRV")
    button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    button.translatesAutoresizingMaskIntoConstraints = false
    return (button)
  }()
  
  fileprivate lazy var walletAddress: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    
    let title = UILabel()
    title.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
    title.text = "Verify wallet address again"
    title.translatesAutoresizingMaskIntoConstraints = false
    
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 17)
    label.text = contact.walletAddress
    label.textAlignment = .justified
    label.numberOfLines = 0
    label.lineBreakMode = .byWordWrapping
    label.sizeToFit()
    label.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(title)
    view.addSubview(label)
    
    NSLayoutConstraint.activate([
      title.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
      
      label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      label.topAnchor.constraint(equalTo: title.safeAreaLayoutGuide.bottomAnchor, constant: 5)
    ])
    
    return (view)
  }()
  
  fileprivate let confirmButton: UIButton = {
    let button = IncognitoButton(title: "Send now")
    button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    button.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    return (button)
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.blurView()
    
    view.addSubview(closeButton)
    view.addSubview(image)
    view.addSubview(titleLabel)
    view.addSubview(amountLabel)
    view.addSubview(currencyButton)
    view.addSubview(walletAddress)
    view.addSubview(confirmButton)
    
    NSLayoutConstraint.activate([
      closeButton.topAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.topAnchor,
        constant: 20
      ),
      closeButton.leadingAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.leadingAnchor,
        constant: 20
      ),
      
      image.heightAnchor.constraint(equalToConstant: 80),
      image.widthAnchor.constraint(equalToConstant: 80),
      image.topAnchor.constraint(
        equalTo: closeButton.safeAreaLayoutGuide.bottomAnchor,
        constant: 20
      ),
      image.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
      
      titleLabel.topAnchor.constraint(
        equalTo: image.safeAreaLayoutGuide.bottomAnchor,
        constant: 8
      ),
      titleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
      
      amountLabel.topAnchor.constraint(
        equalTo: titleLabel.safeAreaLayoutGuide.bottomAnchor,
        constant: 30
      ),
      amountLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
      
      currencyButton.topAnchor.constraint(
        equalTo: amountLabel.safeAreaLayoutGuide.bottomAnchor,
        constant: 10
      ),
      currencyButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
      
      walletAddress.leadingAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.leadingAnchor,
        constant: 30
      ),
      walletAddress.trailingAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.trailingAnchor,
        constant: -30
      ),
      walletAddress.topAnchor.constraint(
        equalTo: currencyButton.safeAreaLayoutGuide.bottomAnchor,
        constant: 100
      ),
      walletAddress.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
      
      confirmButton.heightAnchor.constraint(equalToConstant: 70),
      confirmButton.widthAnchor.constraint(equalToConstant: 150),
      confirmButton.topAnchor.constraint(
        greaterThanOrEqualTo: walletAddress.safeAreaLayoutGuide.bottomAnchor,
        constant: 200
      ),
      confirmButton.bottomAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.bottomAnchor,
        constant: -30
      ),
      confirmButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
    ])
  }
  
  @objc final public func closeButtonTapped() {
    print("Payment close button tapped.")
    self.dismiss(animated: true)
  }
  
  @objc final public func confirmButtonTapped() {
    print("Payment confirm button tapped.")
    
    do {
      let keychain = WalletDataKeychain()
      let walletData = try keychain.retrieve()
      
      print(walletData.privateKey)
    } catch {
      print("Error load wallet from Keychain: \(error).")
    }
  }
}
