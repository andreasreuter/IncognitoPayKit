//
//  RemitteeContact.swift
//  IncognitoPayKit
//
//  Created by Andreas Reuter on 14.03.21.
//  Copyright © 2021 NO DANCE MONKEY. All rights reserved.
//

import Foundation

class RemitteeContact {
  static func synchronise(contactList: [IncognitoContact], completion: @escaping ([IncognitoContact]) -> Void) throws {
    let ids: [String] = contactList.map({ $0.id })
    
    let wallet = WalletAPI()
    try wallet.receiveRemittee(ids: ids) { remittees in
      var remitteeContacts = [IncognitoContact]()
      
      if (remittees.count > 0) {
        for remittee in remittees {
          /*
           * Get contact from contact list by remittee id.
           */
          var contact = contactList.first(where: { $0.id == remittee.id })
          
          if (contact != nil) {
            /*
             * In most cases wallet address is unknown locally.
             */
            contact?.walletAddress = remittee.walletAddress
            
            remitteeContacts.append(contact!)
          }
        }
      }
      
      completion(remitteeContacts)
    }
  }
  
  static func unlinkRemittee(id: String, walletAddress: String, completion: @escaping (Bool) -> Void) throws {
    let unlinkRemittee = UnlinkRemittee(
      id: id,
      walletAddress: walletAddress
    )
    
    let wallet = WalletAPI()
    try wallet.unlinkRemittee(unlinkRemittee: unlinkRemittee) { isUnlinked in
      completion(isUnlinked)
    }
  }
}
