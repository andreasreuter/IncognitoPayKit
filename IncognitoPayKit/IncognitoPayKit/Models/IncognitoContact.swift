//
//  IncognitoContact.swift
//  IncognitoPayKit
//
//  Created by Andreas Reuter on 22.12.20.
//

public struct IncognitoContact {
  private(set) var firstName: String
  private(set) var lastName: String
  private(set) var image: String?
  private(set) var id: String
  public var walletAddress: String
  
  public init(firstName: String, lastName: String, image: String?, id: String, walletAddress: String) {
    self.firstName = firstName
    self.lastName = lastName
    self.image = image
    self.id = id
    self.walletAddress = walletAddress
  }
}
