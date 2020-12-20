//
//  WalletDataKeychain.swift
//  Apfelpatient
//
//  Created by Andreas Reuter on 10.07.20.
//  Copyright © 2020 Milan Jovicic. All rights reserved.
//

import Foundation

struct WalletDataKeychain: Keychain {
  var account = "com.nodancemonkey.IncognitoPayKit.MyWallet"
  var service = "userIdentifier"

  typealias DataType = WalletData
}
