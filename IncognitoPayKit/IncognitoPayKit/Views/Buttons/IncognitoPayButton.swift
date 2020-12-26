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
  
  public required init(base: UIViewController) {
    /*
     * pay button actions cannot be overwritten, therefore it is mandatory
     * to gain access to the outer view controller eg to show action sheet.
     */
    self.base = base
    
    super.init(frame: CGRect.zero)
    
    /*
     * activate event handlers.
     */
    self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
  }
  
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc final public func buttonTapped() {
    print("Incognito Pay button tapped.")
    
    do {
      let keychain = WalletDataKeychain()
      let _ = try keychain.retrieve()
      
      /*
       * If a wallet can be read from the keychain show wallet and payment options.
       */
      let incognitoPayOptions = IncognitoPayOptions(
        sendTo: {
          print("Incognito Pay send coin to.")
          let contacts = ContactView(base: self.base, contactList: [])
          contacts.modalPresentationStyle = .overCurrentContext
          self.base.present(contacts, animated: true)
        },
        receive: {
          print("Incognito Pay receive coin.")
          self.base.present(WalletQRCodeView(base: self.base, codeValue: "xyz"), animated: true)
        }
      )
      
      self.base.present(incognitoPayOptions, animated: true)
    } catch {
      print("Error initialise wallet from Keychain: \(error).")
      
      /*
       * It is assumed that no wallet is stored on this iOS device.
       * Therefore it gives a possibility to either import a wallet
       * or create a new wallet.
       */
      let newWalletOptions = NewWalletOptions(
        newWallet: {
          print("Incognito Pay create new wallet.")
          try? NewWallet.newWallet { wallet in
            self.storeWallet(wallet: wallet)
          }
        },
        importWallet: {
          print("Incognito Pay import wallet.")
        }
      )
      
      self.base.present(newWalletOptions, animated: true)
    }
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
  
  private func storeWallet(wallet: Wallet) {
    let walletData = WalletData(
      privateKey: wallet.privateKey,
      publicKey: wallet.publicKey,
      readonlyKey: wallet.readonlyKey,
      walletAddress: wallet.walletAddress,
      identifier: "Incognito Pay Wallet"
    )

    do {
      // store wallet data in keychain.
      let keychain = WalletDataKeychain()
      try keychain.store(walletData)
    } catch {
      print("Error store wallet in Keychain: \(error).")
    }
  }
}
