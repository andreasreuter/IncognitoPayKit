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
    let sendPayload = WalletSendPayload(
      privateKey: privateKey,
      recipientWalletAddress: walletAddress,
      privacyCoins: privacyCoins
    )
    
    let wallet = WalletAPI()
    try wallet.walletSend(walletSendPayload: sendPayload, completion: { transactionHash in
      completion(transactionHash)
    })
  }
}
