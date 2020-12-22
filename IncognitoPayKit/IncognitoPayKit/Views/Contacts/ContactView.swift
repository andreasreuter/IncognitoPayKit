//
//  ContactView.swift
//  IncognitoPayKit
//
//  Created by Andreas Reuter on 21.12.20.
//

import UIKit

class ContactView: UIViewController {
  private(set) var base: UIViewController
  
  private(set) var contactList: [String]
  
  required init(base: UIViewController, contactList: [String]) {
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
  
  fileprivate let closeButton: UIButton = {
    let button = UIButton()
    let xmark = UIImage(
      systemName: "xmark",
      withConfiguration: UIImage.SymbolConfiguration(scale: .large)
    )
    button.setImage(xmark, for: .normal)
    button.tintColor = .black
    button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    return (button)
  }()
  
  fileprivate let cameraButton: UIButton = {
    let button = UIButton()
    let xmark = UIImage(
      systemName: "qrcode.viewfinder",
      withConfiguration: UIImage.SymbolConfiguration(scale: .large)
    )
    button.setImage(xmark, for: .normal)
    button.tintColor = .black
    button.addTarget(self, action: #selector(cameraButtonTapped), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    return (button)
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.backgroundColor = .white
    
    let tableView = ContactTableView([
        Contact(firstName: "Andreas", lastName: "Reuter", image: "andireuter", walletAddress: "xyz"),
        Contact(firstName: "Susi", lastName: "", walletAddress: "xyz"),
        Contact(firstName: "Seppel", lastName: "", walletAddress: "xyz"),
        Contact(firstName: "Weihnachtsmann", lastName: "", walletAddress: "xyz"),
        Contact(firstName: "Jesus", lastName: "", walletAddress: "xyz"),
        Contact(firstName: "Nuni", lastName: "Wuni", walletAddress: "xyz")
      ],
      contactTapped
    )
    tableView.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(closeButton)
    view.addSubview(cameraButton)
    view.addSubview(tableView)
    
    NSLayoutConstraint.activate([
      closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
      closeButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
      cameraButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
      cameraButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
      tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
      tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
      tableView.topAnchor.constraint(equalTo: closeButton.safeAreaLayoutGuide.bottomAnchor, constant: 20),
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
  
  private func contactTapped(_ contact: Contact) {
    print("Contact row tapped.")
  }
}
