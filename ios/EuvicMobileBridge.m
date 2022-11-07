//
//  EuvicMobileModule.swift
//  EuvicMobileSDK
//
//  Created by Kamil Modzelewski on 21/10/2022.
//  Copyright © 2022 SPEEDNET. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(EuvicMobile, NSObject)

RCT_EXTERN_METHOD(getCurrentUserId: (RCTResponseSenderBlock) callback)
RCT_EXTERN_METHOD(configure: (NSString *) url apiKey: (NSString *) apiKey userId: (NSString *) userId currency: (NSString *) currency allowSensitiveData: (BOOL) allowSensitiveData)
RCT_EXTERN_METHOD(homepageVisitedEvent: (NSDictionary<NSString *, id>) custom)
RCT_EXTERN_METHOD(productBrowsedEvent: (NSDictionary<NSString *, id>) product custom: (NSDictionary<NSString *, id>) custom)
RCT_EXTERN_METHOD(productAddedEvent: (NSDictionary<NSString *, id>) product custom: (NSDictionary<NSString *, id>) custom)
RCT_EXTERN_METHOD(productRemovedEvent: (NSDictionary<NSString *, id>) product custom: (NSDictionary<NSString *, id>) custom)
RCT_EXTERN_METHOD(browsedCategoryEvent: (NSString *) name products: (NSArray<NSDictionary<NSString *, id>>) products custom: (NSDictionary<NSString *, id>) custom)
RCT_EXTERN_METHOD(cartEvent: (NSArray<NSDictionary<NSString *, id>>) products custom: (NSDictionary<NSString *, id>) custom)
RCT_EXTERN_METHOD(orderStartedEvent: (NSDictionary<NSString *, id>) custom)
RCT_EXTERN_METHOD(productsOrderedEvent: (NSString *) orderId saleValue: (NSString *) saleValue products: (NSArray<NSDictionary<NSString *, id>>) products currency: (NSString *) currency custom: (NSDictionary<NSString *, id>) custom)

@end
