//
//  EuvicMobileModule.swift
//  EuvicMobileSDK
//
//  Created by Kamil Modzelewski on 21/10/2022.
//  Copyright © 2022 SPEEDNET. All rights reserved.
//
//

import Foundation
import EuvicMobileSDK

@objc(EuvicMobile)
internal class EuvicMobile: NSObject {
  public override init() {
    super.init()
  }
  
  @objc public func getCurrentUserId(_ callback: RCTResponseSenderBlock) {
    callback([EuvicMobileSDK.EuvicMobile.shared.currentUserId])
  }
  
  @objc public func configure(_ url: String, apiKey: String, userId: String? = nil, currency: String? = nil, allowSensitiveData: Bool = true) {
    DispatchQueue.main.async {
      EuvicMobileSDK.EuvicMobile.shared.config = .init(
        url: url,
        apiKey: apiKey,
        userId: userId,
        currency: currency,
        allowSensitiveData: allowSensitiveData
      )
    }
  }
  
  @objc public func homepageVisitedEvent(_ custom: [String: Any] = [:]) {
    DispatchQueue.main.async {
      EuvicMobileSDK.EuvicMobile.shared.homepageVisitedEvent(custom: custom)
    }
  }
  
  @objc public func productBrowsedEvent(_ product: [String: Any], custom: [String: Any] = [:]) {
      guard
          let id = product["id"] as? String,
          let price = product["price"] as? String,
          let quantity = product["quantity"] as? Int
      else {
          return
      }
      
      let currency = product["currency"] as? String
      let product = EuvicMobileSDK.EuvicMobileProduct(id: id, price: price, currency: currency, quantity: quantity)
      
      EuvicMobileSDK.EuvicMobile.shared.productBrowsedEvent(
          product: product,
          custom: custom
      )
  }
  
  @objc public func productAddedEvent(_ product: [String: Any], custom: [String: Any] = [:]) {
    guard
        let id = product["id"] as? String,
        let price = product["price"] as? String,
        let quantity = product["quantity"] as? Int
    else {
        return
    }
    
    let currency = product["currency"] as? String
    let product = EuvicMobileSDK.EuvicMobileProduct(id: id, price: price, currency: currency, quantity: quantity)
    
    DispatchQueue.main.async {
      EuvicMobileSDK.EuvicMobile.shared.productAddedEvent(
        product: product,
        custom: custom
      )
    }
  }
  
  @objc public func productRemovedEvent(_ product: [String: Any], custom: [String: Any] = [:]) {
    guard
        let id = product["id"] as? String,
        let price = product["price"] as? String,
        let quantity = product["quantity"] as? Int
    else {
        return
    }
    
    let currency = product["currency"] as? String
    let product = EuvicMobileSDK.EuvicMobileProduct(id: id, price: price, currency: currency, quantity: quantity)
    
    DispatchQueue.main.async {
      EuvicMobileSDK.EuvicMobile.shared.productRemovedEvent(
        product: product,
        custom: custom
      )
    }
  }
  
  @objc public func browsedCategoryEvent(_ name: String, products: [[String: Any]], custom: [String: Any] = [:]) {
    var items = [EuvicMobileSDK.EuvicMobileProduct]()
    for product in products {
      guard
          let id = product["id"] as? String,
          let price = product["price"] as? String,
          let quantity = product["quantity"] as? Int
      else {
          continue
      }
      
      let currency = product["currency"] as? String
      items.append(EuvicMobileSDK.EuvicMobileProduct(id: id, price: price, currency: currency, quantity: quantity))
    }
    
    DispatchQueue.main.async {
      EuvicMobileSDK.EuvicMobile.shared.browsedCategoryEvent(
        name: name,
        products: items,
        custom: custom
      )
    }
  }
  
  @objc public func cartEvent(_ products: [[String: Any]], custom: [String: Any] = [:]) {
    var items = [EuvicMobileSDK.EuvicMobileProduct]()
    for product in products {
      guard
          let id = product["id"] as? String,
          let price = product["price"] as? String,
          let quantity = product["quantity"] as? Int
      else {
          continue
      }
      
      let currency = product["currency"] as? String
      items.append(EuvicMobileSDK.EuvicMobileProduct(id: id, price: price, currency: currency, quantity: quantity))
    }
    
    DispatchQueue.main.async {
      EuvicMobileSDK.EuvicMobile.shared.cartEvent(
        products: items,
        custom: custom
      )
    }
  }
  
  @objc public func orderStartedEvent(_ custom: [String: Any] = [:]) {
    DispatchQueue.main.async {
      EuvicMobileSDK.EuvicMobile.shared.orderStartedEvent(
        custom: custom
      )
    }
  }
  
  @objc public func productsOrderedEvent(_ orderId: String, saleValue: String, products:[[String: Any]], currency: String? = nil, custom: [String: Any] = [:]) {
    var items = [EuvicMobileSDK.EuvicMobileProduct]()
    for product in products {
      guard
          let id = product["id"] as? String,
          let price = product["price"] as? String,
          let quantity = product["quantity"] as? Int
      else {
          continue
      }
      
      let currency = product["currency"] as? String
      items.append(EuvicMobileSDK.EuvicMobileProduct(id: id, price: price, currency: currency, quantity: quantity))
    }
    
    DispatchQueue.main.async {
      EuvicMobileSDK.EuvicMobile.shared.productsOrderedEvent(
        orderId: orderId,
        saleValue: saleValue,
        products: items,
        currency: currency,
        custom: custom
      )
    }
  }
  
  @objc internal static func requiresMainQueueSetup() -> Bool {
    return false
  }
}
