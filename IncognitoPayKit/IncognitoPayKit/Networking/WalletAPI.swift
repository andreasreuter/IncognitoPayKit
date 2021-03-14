//
//  WalletAPI.swift
//  IncognitoPayKit
//
//  Created by Andreas Reuter on 20.12.20.
//  Copyright © 2020 NO DANCE MONKEY. All rights reserved.
//

import Foundation

struct ImportWallet: Codable {
  let privateKey: String
  let id: String
  
  enum CodingKeys: String, CodingKey {
    case privateKey
    case id
  }
}

struct WalletSend: Codable {
  let privateKey: String
  let recipientWalletAddress: String
  let privacyCoins: String
  
  enum CodingKeys: String, CodingKey {
    case privateKey
    case recipientWalletAddress
    case privacyCoins
  }
}

class WalletAPI {
  func newWallet(id: String, completion: @escaping (Wallet?) -> Void) throws {
    guard let url = URL(string: try Config.value(for: "REST_API_BASE_URL") + "/NewWallet") else {
      print("Error: cannot get api base url")
      completion(nil)
      return
    }
    
    guard let jsonData = try? JSONEncoder().encode(["id": id]) else {
      print("Error: cannot cast parameters to json")
      completion(nil)
      return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = jsonData
    
    URLSession.shared.dataTask(with: request) { (data, response, error) in
      if let error = error {
        print("Error returning new wallet: \(error)")
        completion(nil)
        return
      }
      
      guard let httpResponse = response as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode) else {
        print("Error unexpecting status code: \(response!)")
        completion(nil)
        return
      }
      
      if let data = data,
         let wallet = try? JSONDecoder().decode(Wallet.self, from: data) {
        completion(wallet)
      }
    }
    .resume()
  }
  
  func importWallet(importWallet: ImportWallet, completion: @escaping (Wallet?) -> Void) throws {
    guard let url = URL(string: try Config.value(for: "REST_API_BASE_URL") + "/ImportWallet") else {
      print("Error: cannot get api base url")
      completion(nil)
      return
    }
    
    guard let jsonData = try? JSONEncoder().encode(importWallet) else {
      print("Error: cannot cast parameters to json")
      completion(nil)
      return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = jsonData
    
    URLSession.shared.dataTask(with: request) { (data, response, error) in
      if let error = error {
        print("Error returning imported wallet: \(error)")
        completion(nil)
        return
      }
      
      guard let httpResponse = response as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode) else {
        print("Error unexpecting status code: \(response!)")
        completion(nil)
        return
      }
      
      if let data = data,
         let wallet = try? JSONDecoder().decode(Wallet.self, from: data) {
        completion(wallet)
      }
      
      print("Error failed wallet import: \(String(decoding: data!, as: UTF8.self))")
      completion(nil)
    }
    .resume()
  }
  
  func walletSend(walletSend: WalletSend, completion: @escaping (String?) -> Void) throws {
    guard let url = URL(string: try Config.value(for: "REST_API_BASE_URL") + "/WalletSend") else {
      print("Error: cannot get api base url")
      completion(nil)
      return
    }
    
    guard let jsonData = try? JSONEncoder().encode(walletSend) else {
      print("Error: cannot cast parameters to json")
      completion(nil)
      return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = jsonData
    
    URLSession.shared.dataTask(with: request) { (data, response, error) in
      if let error = error {
        print("Error returning transaction hash: \(error)")
        completion(nil)
        return
      }
      
      guard let httpResponse = response as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode) else {
        print("Error unexpecting status code: \(response!)")
        completion(nil)
        return
      }
      
      if let data = data,
         let transactionHash = try? JSONDecoder().decode(String.self, from: data) {
        completion(transactionHash)
        return
      }
      
      print("Error invalid transaction hash: \(String(decoding: data!, as: UTF8.self))")
      completion(nil)
    }
    .resume()
  }
  
  func walletBalance(walletAddress: String, completion: @escaping (String) -> Void) throws {
    guard let url = URL(string: try Config.value(for: "REST_API_BASE_URL") + "/WalletBalance") else {
      print("Error: cannot get api base url")
      return
    }
    
    guard let jsonData = try? JSONEncoder().encode(walletAddress) else {
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
  
  func retrieveRemittee(ids: [String], completion: @escaping ([Remittee]) -> Void) throws {
    guard let url = URL(string: try Config.value(for: "REST_API_BASE_URL") + "/RetrieveRemittee") else {
      print("Error: cannot get api base url")
      return
    }
    
    guard let jsonData = try? JSONEncoder().encode(ids) else {
      print("Error: cannot cast parameters to json")
      return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = jsonData
    
    URLSession.shared.dataTask(with: request) { (data, response, error) in
      if let error = error {
        print("Error returning remittees: \(error)")
        return
      }
      
      guard let httpResponse = response as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode) else {
        print("Error unexpecting status code: \(response!)")
        return
      }
      
      if let data = data,
         let remittees = try? JSONDecoder().decode([Remittee].self, from: data) {
        completion(remittees)
      }
    }
    .resume()
  }
}
