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
  
  private var contact: IncognitoContact
  
  private var amount: String
  
  required init(base: UIViewController, contact: IncognitoContact, amount: String) {
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
      ColorCompatibility.label,
      for: .normal
    )
    button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    return (button)
  }()
  
  fileprivate lazy var image: UIImageView = {
    let bundle = Bundle(for: ContactTableCell.self)
    
    let image = UIImage(
      named: contact.image ?? "avatar",
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
      title.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      
      label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      label.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      label.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 5)
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
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
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
        equalTo: closeButton.bottomAnchor,
        constant: 20
      ),
      image.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      
      titleLabel.topAnchor.constraint(
        equalTo: image.bottomAnchor,
        constant: 8
      ),
      titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      
      amountLabel.widthAnchor.constraint(equalToConstant: view.bounds.width / 2),
      amountLabel.topAnchor.constraint(
        equalTo: titleLabel.bottomAnchor,
        constant: 30
      ),
      amountLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      
      currencyButton.topAnchor.constraint(
        equalTo: amountLabel.bottomAnchor,
        constant: 10
      ),
      currencyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      
      walletAddress.leadingAnchor.constraint(
        equalTo: view.leadingAnchor,
        constant: 30
      ),
      walletAddress.trailingAnchor.constraint(
        equalTo: view.trailingAnchor,
        constant: -30
      ),
      walletAddress.topAnchor.constraint(
        equalTo: currencyButton.bottomAnchor,
        constant: 50
      ),
      walletAddress.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      
      confirmButton.heightAnchor.constraint(equalToConstant: 70),
      confirmButton.widthAnchor.constraint(equalToConstant: 150),
      confirmButton.topAnchor.constraint(
        equalTo: walletAddress.bottomAnchor,
        constant: 50
      ),
      confirmButton.bottomAnchor.constraint(
        equalTo: view.bottomAnchor,
        constant: -30
      ),
      confirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
    ])
  }
  
  @objc final public func closeButtonTapped() {
    print("Payment close button tapped.")
    self.dismiss(animated: true)
  }
  
  @objc final public func confirmButtonTapped() {
    print("Payment confirm button tapped.")
    
    let loadingAlert = UIAlertController.loadingAlert(
      text: "Send coins to..."
    )
    self.base.present(loadingAlert, animated: true)
    
    do {
      let keychain = WalletDataKeychain()
      let walletData = try keychain.retrieve()
        
      DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.4) {
        loadingAlert.dismiss(animated: true)
      }

      do {
        try Payment.walletSend(privateKey: walletData.privateKey, walletAddress: contact.walletAddress, privacyCoins: amount) { transactionHash in
          do {
            guard let _ = transactionHash else {
              throw PaymentError.interrupted
            }

            DispatchQueue.main.async {
              loadingAlert.dismiss(animated: true) {
                let activityAlert = UIAlertController.activityAlert(
                  symbolName: "checkmark.circle.fill",
                  text: "Your coins are sent!"
                )
                self.base.present(activityAlert, animated: true)

                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.4) {
                  activityAlert.dismiss(animated: true)
                }
              }
            }
          } catch {
            print("Error send coins via backend: \(error).")

            DispatchQueue.main.async {
              loadingAlert.dismiss(animated: true) {
                let errorAlert = UIAlertController.errorAlert(
                  title: "Coins were not transferred",
                  message: "Cannot send coins from your wallet. Try again!"
                )
                self.base.present(errorAlert, animated: true)
              }
            }
          }
        }
      } catch {
        print("Error send coins via backend: \(error).")

        DispatchQueue.main.async {
          loadingAlert.dismiss(animated: true) {
            let errorAlert = UIAlertController.errorAlert(
              title: "Coins were not transferred",
              message: "Cannot send coins from your wallet: \(error). Try again!"
            )
            self.base.present(errorAlert, animated: true)
          }
        }
      }
    } catch {
      print("Error load wallet from Keychain: \(error).")

      DispatchQueue.main.async {
        loadingAlert.dismiss(animated: true) {
          let errorAlert = UIAlertController.errorAlert(
            title: "Wallet error",
            message: """
              Cannot load wallet from Keychain.
              You must import a wallet or create a new wallet.
              Before you try again!
            """
          )
          self.base.present(errorAlert, animated: true)
        }
      }
    }
  }
}
