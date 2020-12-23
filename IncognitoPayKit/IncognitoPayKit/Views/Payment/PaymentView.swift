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
  
  fileprivate let closeButton: UIButton = {
    let button = UIButton()
    button.setTitle("Cancel", for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    return (button)
  }()
  
  fileprivate lazy var contactInfo: UILabel = {
    let label = UILabel()
    label.text = "You will send to \(contact.firstName) \(contact.lastName)"
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
    let button = IncognitoButton(title: "Preview")
    button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    button.addTarget(self, action: #selector(previewButtonTapped), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    return (button)
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
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
        equalTo: closeButton.safeAreaLayoutGuide.bottomAnchor,
        constant: 20
      ),
      contactInfo.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
      
      amountText.widthAnchor.constraint(equalToConstant: view.bounds.width / 2),
      amountText.topAnchor.constraint(
        equalTo: contactInfo.safeAreaLayoutGuide.bottomAnchor,
        constant: 25
      ),
      amountText.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
      
      currencyButton.topAnchor.constraint(
        equalTo: amountText.safeAreaLayoutGuide.bottomAnchor,
        constant: 10
      ),
      currencyButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
      
      previewButton.heightAnchor.constraint(equalToConstant: 70),
      previewButton.widthAnchor.constraint(equalToConstant: 150),
      previewButton.topAnchor.constraint(
        equalTo: currencyButton.safeAreaLayoutGuide.bottomAnchor,
        constant: 130
      ),
      previewButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
    ])
  }
  
  @objc final public func closeButtonTapped() {
    print("Payment close button tapped.")
    self.dismiss(animated: true)
  }
  
  @objc final public func previewButtonTapped() {
    print("Payment preview button tapped.")
    let payment = PaymentConfirmView(base: self, contact: contact, amount: amountText.text!)
    payment.modalPresentationStyle = .fullScreen
    payment.modalTransitionStyle = .crossDissolve
    self.present(payment, animated: true)
  }
}
