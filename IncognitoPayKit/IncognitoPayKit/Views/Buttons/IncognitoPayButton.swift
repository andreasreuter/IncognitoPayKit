//
//  IncognitoPayButton.swift
//  IncognitoPayKit
//
//  Created by Andreas Reuter on 23.11.20.
//  Copyright © 2020 NO DANCE MONKEY. All rights reserved.
//

import UIKit

public class IncognitoPayButton: UIButton {
  private(set) var base: UIViewController
  
  private let cgSize: CGSize = CGSize(width: 100, height: 50)
  
  private let spacing: CGFloat = 5
  
  public required init(base: UIViewController) {
    /*
     * pay button actions cannot be overwritten, therefore it is mandatory
     * to gain access to the outer view controller eg to show action sheet.
     */
    self.base = base
    
    super.init(frame: CGRect.zero)
    
    /*
     * other function calls are available after super constructor
     * is called.
     */
    self.button()
    
    /*
     * activate event handlers.
     */
    self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
  }
  
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override class func awakeFromNib() {
    super.awakeFromNib()
  }
  
  @objc final public func buttonTapped() {
    print("Incognito Pay button tapped.")
    
    let actionSheet = IncognitoPayButtonActions(
      importWallet: {
        print("Incognito Pay import wallet.")
      },
      sendTo: {
        print("Incognito Pay send coin to.")
        let contacts = ContactView(base: self.base, contactList: [])
        contacts.modalPresentationStyle = .fullScreen
        self.base.present(contacts, animated: true)
      },
      receive: {
        print("Incognito Pay receive coin.")
        self.base.present(WalletQRCodeView(base: self.base, codeValue: "xyz"), animated: true)
      }
    )
    self.base.present(actionSheet, animated: true)
  }
  
  private func incognitoLogo() -> UIImage? {
    let bundle = Bundle(for: IncognitoPayButton.self)
    let logo = UIImage(
      named: "incognito-black-dot",
      in: bundle,
      compatibleWith: nil
    )
    return (logo)
  }
  
  private func button() {
    /*
     * design its normal button behaviour.
     */
    setTitle("Pay", for: .normal)
    setTitleColor(UIColor.black, for: .normal)
    titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
    setImage(incognitoLogo(), for: .normal)
    backgroundColor = UIColor(red: 243/255, green: 243/255, blue: 243/255, alpha: 1.0)
    layer.cornerRadius = 25
    
    /*
     * always set same button size for all button behaviours.
     */
    frame.size = cgSize
    
    imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: spacing)
    titleEdgeInsets = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: 0)
  }
}
