//
//  ContactView.swift
//  IncognitoPayKit
//
//  Created by Andreas Reuter on 21.12.20.
//  Copyright © 2020 NO DANCE MONKEY. All rights reserved.
//

import UIKit

class ContactView: UIViewController {
  private(set) var base: UIViewController
  
  private(set) var contactList: [IncognitoContact] = [IncognitoContact]()
  
  required init(base: UIViewController, contactList: [IncognitoContact]) {
    /*
     * contact view cannot be overwritten, therefore it is mandatory
     * to gain access to the outer view controller eg to show them.
     */
    self.base = base
    self.contactList = contactList
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
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
  
  fileprivate lazy var cameraButton: UIButton = {
    let button = UIButton()
    let qrCode: UIImage?
    
    if #available(iOS 13.0, *) {
      qrCode = UIImage(
        systemName: "qrcode.viewfinder",
        withConfiguration: UIImage.SymbolConfiguration(scale: .large)
      )
    } else {
      // Fallback on earlier versions
      qrCode = UIImage(named: "qrcode")
    }
    
    button.setImage(qrCode, for: .normal)
    button.tintColor = ColorCompatibility.label
    button.translatesAutoresizingMaskIntoConstraints = false
    return (button)
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.blurView()
    
    /*
     * Cannot add button targets in initial function because at this time
     * the handler isn't available.
     */
    closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    cameraButton.addTarget(self, action: #selector(cameraButtonTapped), for: .touchUpInside)
    
    let tableView = ContactTableView([], contactTapped)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(closeButton)
    view.addSubview(cameraButton)
    view.addSubview(tableView)
    
    /*
     * exclude contacts from contact list who are unkown remittee contacts.
     */
    try? RemitteeContact.synchronise(contactList: contactList) { remitteeContacts in
      DispatchQueue.main.async {
        tableView.contactList = remitteeContacts
        tableView.reloadData()
      }
    }
    
    NSLayoutConstraint.activate([
      closeButton.topAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.topAnchor,
        constant: 20
      ),
      closeButton.leadingAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.leadingAnchor,
        constant: 20
      ),
      
      cameraButton.topAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.topAnchor,
        constant: 20
      ),
      cameraButton.trailingAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.trailingAnchor,
        constant: -20
      ),
      
      tableView.leadingAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.leadingAnchor,
        constant: 20
      ),
      tableView.trailingAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.trailingAnchor,
        constant: -20
      ),
      tableView.topAnchor.constraint(
        equalTo: closeButton.safeAreaLayoutGuide.bottomAnchor,
        constant: 20
      )
    ])
  }
  
  @objc final public func closeButtonTapped() {
    print("Contact list close button tapped.")
    self.dismiss(animated: true)
  }
  
  @objc final public func cameraButtonTapped() {
    print("Contact list open camera button tapped.")
    let camera = QRCodeCameraView(base: self)
    camera.modalPresentationStyle = .fullScreen
    self.present(camera, animated: true)
  }
  
  private func contactTapped(_ contact: IncognitoContact) {
    print("Contact row tapped.")
    let payment = PaymentView(base: self, contact: contact)
    payment.modalPresentationStyle = .overCurrentContext
    payment.modalTransitionStyle = .crossDissolve
    self.present(payment, animated: true)
  }
}
