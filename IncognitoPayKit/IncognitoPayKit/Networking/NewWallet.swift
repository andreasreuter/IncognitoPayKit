//
//  NewWallet.swift
//  IncognitoPayKit
//
//  Created by Andreas Reuter on 25.12.20.
//  Copyright © 2020 NO DANCE MONKEY. All rights reserved.
//

import Foundation

class NewWallet {
  static func newWallet(id: String, completion: @escaping (Wallet?) -> Void) throws {
    let wallet = WalletAPI()
    try wallet.newWallet(id: id, completion: { wallet in
      completion(wallet)
    })
  }
  
  static func importWallet(privateKey: String, id: String, completion: @escaping (Wallet?) -> Void) throws {
    let importWallet = ImportWallet(privateKey: privateKey, id: id)
    
    let wallet = WalletAPI()
    try wallet.importWallet(importWallet: importWallet, completion: { wallet in
      completion(wallet)
    })
  }
}
