//
//  PaymentView.swift
//  IncognitoPayKit
//
//  Created by Andreas Reuter on 22.12.20.
//  Copyright © 2020 NO DANCE MONKEY. All rights reserved.
//

import UIKit

class PaymentView: UIViewController, UITextFieldDelegate {
  private(set) var base: UIViewController
  
  private var contact: Contact
  
  required init(base: UIViewController, contact: Contact) {
    /*
     * payment view cannot be overwritten, therefore it is mandatory
     * to gain access to the outer view controller eg to show them.
     */
    self.base = base
    self.contact = contact
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  fileprivate lazy var closeButton: UIButton = {
    let button = UIButton()
    button.setTitle("Cancel", for: .normal)
    button.setTitleColor(
      ColorCompatibility.label,
      for: .normal
    )
    button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    return (button)
  }()
  
  fileprivate lazy var contactInfo: UILabel = {
    let label = UILabel()
    label.text = "You send to \(contact.firstName) \(contact.lastName)"
    label.translatesAutoresizingMaskIntoConstraints = false
    return (label)
  }()
  
  fileprivate lazy var amountText: UITextField = {
    let textField = UITextField()
    textField.font = UIFont.systemFont(ofSize: 70, weight: .medium)
    textField.text = "0.00"
    textField.textAlignment = .center
    textField.keyboardType = .decimalPad
    textField.delegate = self
    textField.translatesAutoresizingMaskIntoConstraints = false
    return (textField)
  }()
  
  fileprivate let currencyButton: UIButton = {
    let button = IncognitoButton(title: "PRV")
    button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    button.translatesAutoresizingMaskIntoConstraints = false
    return (button)
  }()
  
  fileprivate let previewButton: UIButton = {
    let button = IncognitoButton(title: "Show preview")
    button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    button.addTarget(self, action: #selector(previewButtonTapped), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    return (button)
  }()
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    view.blurView()
    
    view.addSubview(closeButton)
    view.addSubview(contactInfo)
    view.addSubview(amountText)
    view.addSubview(currencyButton)
    view.addSubview(previewButton)
    
    NSLayoutConstraint.activate([
      closeButton.topAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.topAnchor,
        constant: 20
      ),
      closeButton.leadingAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.leadingAnchor,
        constant: 20
      ),
      
      contactInfo.topAnchor.constraint(
        equalTo: closeButton.bottomAnchor,
        constant: 20
      ),
      contactInfo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      
      amountText.widthAnchor.constraint(equalToConstant: view.bounds.width / 2),
      amountText.topAnchor.constraint(
        equalTo: contactInfo.bottomAnchor,
        constant: 25
      ),
      amountText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      
      currencyButton.topAnchor.constraint(
        equalTo: amountText.bottomAnchor,
        constant: 10
      ),
      currencyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      
      previewButton.heightAnchor.constraint(equalToConstant: 70),
      previewButton.widthAnchor.constraint(equalToConstant: 150),
      previewButton.topAnchor.constraint(
        equalTo: currencyButton.bottomAnchor,
        constant: 100
      ),
      previewButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
    ])
  }
  
  @objc final public func closeButtonTapped() {
    print("Payment close button tapped.")
    
    /*
     * dismiss keyboard, before present other views.
     */
    view.endEditing(true)
    
    self.dismiss(animated: true)
  }
  
  @objc final public func previewButtonTapped() {
    print("Payment preview button tapped.")
    
    /*
     * dismiss keyboard, before present other views.
     */
    view.endEditing(true)
    
    let paymentConfirm = PaymentConfirmView(base: self, contact: contact, amount: amountText.text!)
    paymentConfirm.modalPresentationStyle = .overCurrentContext
    paymentConfirm.modalTransitionStyle = .crossDissolve
    self.present(paymentConfirm, animated: true)
  }
}
