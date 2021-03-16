//
//  Payment.swift
//  IncognitoPayKit
//
//  Created by Andreas Reuter on 26.12.20.
//  Copyright © 2020 NO DANCE MONKEY. All rights reserved.
//

import Foundation

class Payment {
  static func walletSend(privateKey: String, walletAddress: String, privacyCoins: String, completion: @escaping (String?) -> Void) throws {
    guard let uintCoins = try Self.convertPrivacyCoins(in: privacyCoins) else {
      throw PaymentError.interrupted
    }
    
    let walletSend = WalletSend(
      privateKey: privateKey,
      recipientWalletAddress: walletAddress,
      privacyCoins: String(uintCoins)
    )
    
    let wallet = WalletAPI()
    try wallet.walletSend(walletSend: walletSend, completion: { transactionHash in
      completion(transactionHash)
    })
  }
  
  static private func convertPrivacyCoins(in privacyCoins: String) throws -> UInt64? {
    let trimmedCoins = privacyCoins
      .trimmingCharacters(in: .whitespaces)
      .replacingOccurrences(of: ",", with: ".")
    
    if (!Self.isPrivacyCoinGenuine(in: trimmedCoins)) {
      throw PrivacyCoinGenuineError.invalid
    }
    
    if let floatCoins = Float(trimmedCoins) {
      let uintCoins = floatCoins * 100000000
      
      return (UInt64(uintCoins))
    }
    
    return (nil)
  }
  
  static func isPrivacyCoinGenuine(in privacyCoins: String) -> Bool {
    let regex = try! NSRegularExpression(pattern: "[^0-9.,]+")
    
    let isGenuine = regex.firstMatch(
      in: privacyCoins,
      options: [],
      range: NSRange(location: 0, length: privacyCoins.utf16.count)
    )
    
    return (isGenuine == nil)
  }
}
