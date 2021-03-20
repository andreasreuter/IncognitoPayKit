//
//  IncognitoPayButton.swift
//  IncognitoPayKit
//
//  Created by Andreas Reuter on 23.11.20.
//  Copyright © 2020 NO DANCE MONKEY. All rights reserved.
//

import UIKit

public class IncognitoPayButton: UIButton, CAAnimationDelegate {
  private(set) var base: UIViewController
  
  private let cgSize: CGSize = CGSize(width: 100, height: 50)
  
  private let spacing: CGFloat = 35
  
  private var contactList: [IncognitoContact]
  
  private let id: String
  
  public required init(base: UIViewController, contactList: [IncognitoContact], id: String) {
    /*
     * pay button actions cannot be overwritten, therefore it is mandatory
     * to gain access to the outer view controller eg to show action sheet.
     */
    self.base = base
    self.contactList = contactList
    self.id = id
    
    super.init(frame: CGRect.zero)
    
    /*
     * activate event handlers.
     */
    self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    
    if #available(iOS 13.0, *) {
      self.addInteraction(UIContextMenuInteraction(delegate: self))
    } else {
      // Fallback on earlier versions
      self.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(buttonLongPressed)))
    }
  }
  
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc final public func buttonTapped() {
    print("Incognito Pay button tapped.")
    
    do {
      let keychain = WalletDataKeychain()
      let _ = try keychain.read()
      
      /*
       * If a wallet can be read from the keychain show wallet and payment options.
       */
      print("Incognito Pay send coin to.")
      
      let contacts = ContactView(base: self.base, contactList: self.contactList)
      contacts.modalPresentationStyle = .overCurrentContext
      
      self.base.present(contacts, animated: true)
    } catch {
      print("Error initialise wallet from Keychain: \(error).")
      
      /*
       * It is assumed that no wallet is stored on this iOS device.
       * Therefore it gives a possibility to either import a wallet
       * or create a new wallet.
       */
      let newWalletOptions = NewWalletOptions(
        newWallet: { [self] _ in
          print("Incognito Pay create new wallet.")
          
          let loadingAlert = UIAlertController.loadingAlert(
            text: "New wallet..."
          )
          self.base.present(loadingAlert, animated: true)
          
          do {
            try NewWallet.newWallet(id: id) { wallet in
              do {
                guard let _ = wallet else {
                  throw WalletError.nilWallet
                }
                
                try WalletData.storeWallet(wallet: wallet!)

                DispatchQueue.main.async {
                  loadingAlert.dismiss(animated: true) {
                    let activityAlert = UIAlertController.activityAlert(
                      symbolName: "rectangle.fill.badge.plus",
                      text: "Wallet created!"
                    )
                    self.base.present(activityAlert, animated: true)
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.4) {
                      activityAlert.dismiss(animated: true)
                    }
                  }
                }
              } catch is WalletError {
                print("Error create wallet via backend.")
                
                DispatchQueue.main.async {
                  loadingAlert.dismiss(animated: true) {
                    let errorAlert = UIAlertController.errorAlert(
                      title: "Wallet error",
                      message: "Cannot create wallet. Try again!"
                    )
                    self.base.present(errorAlert, animated: true)
                  }
                }
              } catch {
                print("Error store wallet in Keychain: \(error).")
                
                DispatchQueue.main.async {
                  loadingAlert.dismiss(animated: true) {
                    let errorAlert = UIAlertController.errorAlert(
                      title: "Wallet error",
                      message: "Cannot store wallet in Keychain. Try again!"
                    )
                    self.base.present(errorAlert, animated: true)
                  }
                }
              }
            }
          } catch {
            print("Error create wallet via backend: \(error).")
            
            DispatchQueue.main.async {
              loadingAlert.dismiss(animated: true) {
                let errorAlert = UIAlertController.errorAlert(
                  title: "Wallet error",
                  message: "Cannot create wallet. Try again!"
                )
                self.base.present(errorAlert, animated: true)
              }
            }
          }
        },
        importWallet: { [self] _ in
          print("Incognito Pay import wallet.")
          self.base.present(ImportWalletView(id: id), animated: true)
        }
      )
      
      self.base.present(newWalletOptions, animated: true)
    }
  }
  
  @objc final public func buttonLongPressed(_ sender: UIButton) {
    print("Incognito Pay button long pressed.")
    
    let walletPopout = WalletPopoutButtons(base: self.base)
    self.base.present(walletPopout, animated: true)
  }
  
  private func incognitoLogo() -> UIImageView {
    let bundle = Bundle(for: IncognitoPayButton.self)
    let logo = UIImage(
      named: "incognito-black-dot",
      in: bundle,
      compatibleWith: nil
    )
    
    let imageView = UIImageView(image: logo)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return (imageView)
  }
  
  fileprivate lazy var indicationColor: CAGradientLayer = {
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame =  CGRect(origin: CGPoint.zero, size: frame.size)
    gradientLayer.colors = [
      UIColor(red: 135/255, green: 238/255, blue: 253/255, alpha: 1).cgColor,
      UIColor(red: 92/255, green: 163/255, blue: 246/255, alpha: 1).cgColor,
      UIColor(red: 67/255, green: 118/255, blue: 208/255, alpha: 1).cgColor,
      UIColor(red: 47/255, green: 84/255, blue: 136/255, alpha: 1).cgColor
    ]
    gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
    gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)

    let shape = CAShapeLayer()
    shape.lineWidth = 10
    shape.path = UIBezierPath(roundedRect: bounds, cornerRadius: 25).cgPath
    shape.strokeColor = UIColor.black.cgColor
    shape.fillColor = UIColor.clear.cgColor
    gradientLayer.mask = shape
    
    return (gradientLayer)
  }()
  
  private func animateIndicationColor(gradientLayer: CAGradientLayer) -> CAGradientLayer {
    let colorsAnimation = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.colors))
    colorsAnimation.fromValue = gradientLayer.colors
    colorsAnimation.toValue = [
      UIColor(red: 47/255, green: 84/255, blue: 136/255, alpha: 1).cgColor,
      UIColor(red: 67/255, green: 118/255, blue: 208/255, alpha: 1).cgColor,
      UIColor(red: 92/255, green: 163/255, blue: 246/255, alpha: 1).cgColor,
      UIColor(red: 135/255, green: 238/255, blue: 253/255, alpha: 1).cgColor
    ]
    colorsAnimation.duration = 1.8
    colorsAnimation.delegate = self
    colorsAnimation.fillMode = .forwards
    colorsAnimation.repeatCount = .infinity
    colorsAnimation.autoreverses = true
    colorsAnimation.isRemovedOnCompletion = false
  
    gradientLayer.add(colorsAnimation, forKey: "colors")
    
    return (gradientLayer)
  }
  
  public override func willMove(toWindow newWindow: UIWindow?) {
    super.willMove(toWindow: newWindow)
    
    /*
     * always set same button size for all button behaviours.
     */
    frame.size = cgSize
    
    /*
     * design its normal button behaviour.
     */
    blurView(alwaysLight: true)
    
    let logoView = incognitoLogo()
    addSubview(logoView)
    
    setTitle("Pay", for: .normal)
    setTitleColor(UIColor.black, for: .normal)
    titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
    layer.addSublayer(animateIndicationColor(gradientLayer: indicationColor))
    layer.cornerRadius = 25
    layer.masksToBounds = true
    clipsToBounds = true
    
    imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: spacing)
    titleEdgeInsets = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: 0)
    
    NSLayoutConstraint.activate([
      logoView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 15),
      logoView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor)
    ])
  }
}
