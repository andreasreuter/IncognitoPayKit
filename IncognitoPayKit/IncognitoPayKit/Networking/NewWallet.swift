//
//  NewWallet.swift
//  IncognitoPayKit
//
//  Created by Andreas Reuter on 25.12.20.
//

import Foundation

class NewWallet {
  static func newWallet(completion: @escaping (Wallet?) -> Void) throws {
    let wallet = WalletAPI()
    try wallet.newWallet(completion: { wallet in
      completion(wallet)
    })
  }
  
  static func importWallet(privateKey: String, completion: @escaping (Wallet?) -> Void) throws {
    let importPayload = WalletImportPayload(privateKey: privateKey)
    
    let wallet = WalletAPI()
    try wallet.importWallet(walletImportPayload: importPayload, completion: { wallet in
      completion(wallet)
    })
  }
}
