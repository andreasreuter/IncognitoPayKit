//
//  Wallet.swift
//  IncognitoPayKit
//
//  Created by Andreas Reuter on 20.12.20.
//  Copyright © 2020 NO DANCE MONKEY. All rights reserved.
//

struct Wallet: Codable {
  let privateKey: String
  let publicKey: String
  let readonlyKey: String
  let walletAddress: String
  
  enum CodingKeys: String, CodingKey {
    case privateKey
    case publicKey
    case readonlyKey
    case walletAddress
  }
}
