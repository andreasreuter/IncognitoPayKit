//
//  WalletDataKeychain.swift
//  IncognitoPayKit
//
//  Created by Andreas Reuter on 28.11.20.
//  Copyright © 2020 NO DANCE MONKEY. All rights reserved.
//

import Foundation

struct WalletDataKeychain: Keychain {
  var account = "com.nodancemonkey.IncognitoPayKit.MyWallet"
  var service = "userIdentifier"

  typealias DataType = WalletData
}
