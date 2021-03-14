//
//  Remittee.swift
//  IncognitoPayKit
//
//  Created by Andreas Reuter on 14.03.21.
//  Copyright © 2021 NO DANCE MONKEY. All rights reserved.
//

struct Remittee: Codable {
  let id: String
  let walletAddress: String
  
  enum CodingKeys: String, CodingKey {
    case id
    case walletAddress
  }
}
