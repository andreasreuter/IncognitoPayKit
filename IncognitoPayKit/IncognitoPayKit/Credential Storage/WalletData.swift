//
//  WalletData.swift
//  IncognitoPayKit
//
//  Created by Andreas Reuter on 28.11.20.
//  Copyright © 2020 NO DANCE MONKEY. All rights reserved.
//

import Foundation

struct WalletData {
  var privateKey: String
  var publicKey: String
  var readonlyKey: String
  var walletAddress: String
  var identifier: String
}

extension WalletData: Codable {
  enum CodingKeys: String, CodingKey {
    case privateKey
    case publicKey
    case readonlyKey
    case walletAddress
    case identifier
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    privateKey = try container.decode(String.self, forKey: .privateKey)
    publicKey = try container.decode(String.self, forKey: .publicKey)
    readonlyKey = try container.decode(String.self, forKey: .readonlyKey)
    walletAddress = try container.decode(String.self, forKey: .walletAddress)
    identifier = try container.decode(String.self, forKey: .identifier)
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(privateKey, forKey: .privateKey)
    try container.encode(publicKey, forKey: .publicKey)
    try container.encode(readonlyKey, forKey: .readonlyKey)
    try container.encode(walletAddress, forKey: .walletAddress)
    try container.encode(identifier, forKey: .identifier)
  }
  
  static func storeWallet(wallet: Wallet) throws {
    let walletData = WalletData(
      privateKey: wallet.privateKey,
      publicKey: wallet.publicKey,
      readonlyKey: wallet.readonlyKey,
      walletAddress: wallet.walletAddress,
      identifier: "Incognito Pay Wallet"
    )

    // store wallet data in keychain.
    let keychain = WalletDataKeychain()
    try keychain.store(walletData)
  }
}
