//
//  Keychain.swift
//  IncognitoPayKit
//
//  Created by Andreas Reuter on 28.11.20.
//  Copyright © 2020 NO DANCE MONKEY. All rights reserved.
//

import Foundation

enum KeychainError: Error {
  case secCallFailed(OSStatus)
  case notFound
  case badData
  case archiveFailure(Error)
}

protocol Keychain {
  associatedtype DataType: Codable

  var account: String { get set }
  var service: String { get set }

  func delete() throws
  func read() throws -> DataType
  func store(_ data: DataType) throws
}

extension Keychain {
  func delete() throws {
    let status = SecItemDelete(keychainQuery() as CFDictionary)
    guard status == noErr || status == errSecItemNotFound else {
      throw KeychainError.secCallFailed(status)
    }
  }
  
  func read() throws -> DataType {
    var query = keychainQuery()
    query[kSecMatchLimit as String] = kSecMatchLimitOne
    query[kSecReturnAttributes as String] = kCFBooleanTrue
    query[kSecReturnData as String] = kCFBooleanTrue

    var result: AnyObject?
    let status = withUnsafeMutablePointer(to: &result) {
      SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
    }

    guard status != errSecItemNotFound
      else {
        throw KeychainError.notFound
      }
    
    guard status == noErr
      else {
        throw KeychainError.secCallFailed(status)
      }

    do {
      guard
        let dict = result as? [String: AnyObject],
        let data = dict[kSecAttrGeneric as String] as? Data,
        let unarchived = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? Data
      else {
        throw KeychainError.badData
      }
      
      let keychainData = try PropertyListDecoder().decode(DataType.self, from: unarchived) as DataType
      
      return (keychainData)
    } catch {
      throw KeychainError.archiveFailure(error)
    }
  }

  func store(_ data: DataType) throws {
    var query = keychainQuery()

    let archived: AnyObject
    do {
      let encoded = try PropertyListEncoder().encode(data)
      archived = try NSKeyedArchiver.archivedData(withRootObject: encoded, requiringSecureCoding: true) as AnyObject
    } catch {
      throw KeychainError.archiveFailure(error)
    }

    let status: OSStatus
    do {
      // If doesn't already exist, this will throw a KeychainError.notFound,
      // causing the catch block to add it.
      let _ = try read()

      let updates = [
        String(kSecAttrGeneric): archived
      ]

      status = SecItemUpdate(query as CFDictionary, updates as CFDictionary)
    } catch KeychainError.notFound {
      query[kSecAttrGeneric as String] = archived
      status = SecItemAdd(query as CFDictionary, nil)
    } 

    guard status == noErr
      else {
        throw KeychainError.secCallFailed(status)
      }
  }

  private func keychainQuery() -> [String: AnyObject] {
    var query: [String: AnyObject] = [:]
    query[kSecClass as String] = kSecClassGenericPassword
    query[kSecAttrService as String] = service as AnyObject
    query[kSecAttrAccount as String] = account as AnyObject

    return (query)
  }
}
