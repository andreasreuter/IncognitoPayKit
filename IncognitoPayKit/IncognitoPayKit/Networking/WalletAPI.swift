//
//  WalletAPI.swift
//  IncognitoPayKit
//
//  Created by Andreas Reuter on 20.12.20.
//  Copyright © 2020 NO DANCE MONKEY. All rights reserved.
//

import Foundation

struct WalletSendPayload: Codable {
  let privateKey: String
  let recipientWalletAddress: String
  let privacyCoins: String
  
  enum CodingKeys: String, CodingKey {
    case privateKey
    case recipientWalletAddress
    case privacyCoins
  }
}

struct WalletBalancePayload: Codable {
  let walletAddress: String
  
  enum CodingKeys: String, CodingKey {
    case walletAddress
  }
}

class WalletAPI {
  func newWallet(completion: @escaping (Wallet) -> Void) throws {
    guard let url = URL(string: try Config.value(for: "REST_API_BASE_URL") + "/NewWallet") else {
      print("Error: cannot get api base url")
      return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    URLSession.shared.dataTask(with: request) { (data, response, error) in
      if let error = error {
        print("Error returning new wallet: \(error)")
        return
      }
      
      guard let httpResponse = response as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode) else {
        print("Error unexpecting status code: \(response!)")
        return
      }
      
      if let data = data,
         let wallet = try? JSONDecoder().decode(Wallet.self, from: data) {
        completion(wallet)
      }
    }
    .resume()
  }
  
  func walletSend(walletSendPayload: WalletSendPayload, completion: @escaping (String) -> Void) throws {
    guard let url = URL(string: try Config.value(for: "REST_API_BASE_URL") + "/WalletSend") else {
      print("Error: cannot get api base url")
      return
    }
    
    guard let jsonData = try? JSONEncoder().encode(walletSendPayload) else {
      print("Error: cannot cast parameters to json")
      return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = jsonData
    
    URLSession.shared.dataTask(with: request) { (data, response, error) in
      if let error = error {
        print("Error returning transaction hash: \(error)")
        return
      }
      
      guard let httpResponse = response as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode) else {
        print("Error unexpecting status code: \(response!)")
        return
      }
      
      if let data = data,
         let transactionHash = try? JSONDecoder().decode(String.self, from: data) {
        completion(transactionHash)
      }
    }
    .resume()
  }
  
  func walletBalance(walletBalancePayload: WalletBalancePayload, completion: @escaping (String) -> Void) throws {
    guard let url = URL(string: try Config.value(for: "REST_API_BASE_URL") + "/WalletBalance") else {
      print("Error: cannot get api base url")
      return
    }
    
    guard let jsonData = try? JSONEncoder().encode(walletBalancePayload) else {
      print("Error: cannot cast parameters to json")
      return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = jsonData
    
    URLSession.shared.dataTask(with: request) { (data, response, error) in
      if let error = error {
        print("Error returning wallet balance: \(error)")
        return
      }
      
      guard let httpResponse = response as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode) else {
        print("Error unexpecting status code: \(response!)")
        return
      }
      
      if let data = data,
         let walletBalance = try? JSONDecoder().decode(String.self, from: data) {
        completion(walletBalance)
      }
    }
    .resume()
  }
}
