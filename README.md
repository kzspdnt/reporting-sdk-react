# Euvic Mobile SDK React Native

## System Requirements

Android 7.0+\
iOS 13.0+

## Installation

### Android

Add this dependency to your module's `build.gradle` file:

**Kotlin**
```kotlin
dependencies {
	...
	implementation("io.github.clickonometrics.android:clickonometrics:1.0")
}
```

**Groovy**
```groovy
dependencies {
	...
	implementation 'io.github.clickonometrics.android:clickonometrics:1.0'
}
```

You need is to copy native bridge files [EuvicSdkTrackerAndroidPackage.java](https://github.com/Clickonometrics/reporting-sdk-react/blob/main/android/app/src/main/java/com/euvicsdkreactnativedemo/EuvicSdkTrackerAndroidPackage.java) and [EuvicMobile.java](https://github.com/Clickonometrics/reporting-sdk-react/blob/main/android/app/src/main/java/com/euvicsdkreactnativedemo/EuvicMobile.java) to your project. 
Rememeber to add ```java packages.add(new EuvicSdkTrackerAndroidPackage());``` line to your [MainApplication.java](https://github.com/Clickonometrics/reporting-sdk-react/blob/main/android/app/src/main/java/com/euvicsdkreactnativedemo/MainApplication.java#L30) file.

### iOS

The library is available via Cocapods so you need add dependency to your Podfile
```
pod 'EuvicMobileSDK', '~> 0.2.0'
```

You can also use framework binary file `EuvicMobileSDK.xcframework` and add it to your project.

All you need is to copy native bridge files [EuvicMobileBridge.m](https://github.com/Clickonometrics/reporting-sdk-react/blob/main/ios/EuvicMobileBridge.m) and [EuvicMobile.swift](https://github.com/Clickonometrics/reporting-sdk-react/blob/main/ios/EuvicMobile.swift) to your project. 

And add following import to your project bridging header:
```obj-c
#import <React/RCTBridgeModule.h>
```

You can now use the library in the React Native codebase. 

## Configuration

Before sending events configuration is required. We recommend to do it just after starting the app, because all events submitted earlier will not be sent.
Simply add the following code to your AppDelegate.swift

```typescript
  import { NativeModules } from 'react-native';

  const url = 'https://delivery.clickonometrics.pl/tracker=multi/track/multi/track.json';
  const apiKey = 'your-api-key';
  NativeModules.EuvicMobile.configure(url, apiKey, null, null, true);
```
| Param      | Type    | Description                                                                                                                                                                                          | Note     |
|------------|---------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------|
| `url`      | String  | represents events api                                                                                                                                                                                | Required |
| `apiKey`   | String  | Euvic SDK api key                                                                                                                                                                                    | Required |
| `userId`   | String  | Unique ID representing user. Will be overwritten if system IDFA is available                                                                                                                                | Optional |
| `currency` | String  | Represents default shop currency. If currency is not provided for each product, this value will be used. Should be a three letter value consistent with ISO 4217 norm. Default value is EUR. | Optional |
| `allowSensitiveData` | Bool  | Determines if the library should track sensitive user data such as location or IP address. Default value is true. | Optional |


### Android Advertising ID (AAID)

It's **required** to provide the application with the AAID. Only with this identifier it's possible to show ads to the given user.

If user's privacy policy on the device does not permit the personalized advertising - no ads will be shown. Euvic Mobile SDK will still report user activity for statistical purposes.

To provide system ad identifier add this line to your `AndroidManifest.xml` file:
```xml
<manifest xlmns:android...>
 ...
 <uses-permission android:name="com.google.android.gms.permission.AD_ID"/>
 <application ...
</manifest>
```

### iOS Advertising ID
To use system ad identifier you need to request for tracking authorization in your app.\
Remember to add `NSUserTrackingUsageDescription` in your Info.plist

### Android Location Tracking

To allow library to track user's location you need to request about location permission in your app before sending an event.\
Remember to add this line to your ```AndroidManifest.xml``` file.
```xml
<manifest xlmns:android...>
 ...
 <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
 <application ...
</manifest>
```

### iOS Location Tracking

To send current user location you need to request for tracking authorization in your app.\
Remember to add `NSLocationWhenInUseUsageDescription` in your Info.plist

## Sending events

### Homepage Visited Event

This event should be sent when user has visited a home page.

```typescript
  const custom = {"string": "text", "int": 22, "bool": true}
  NativeModules.EuvicMobile.homepageVisitedEvent(custom)
```

| Param  | Type | Description | Note |
| --- | --- | --- | --- |
| `custom` | [String: Any] | represents custom data as dictionary | Optional |

### Product Browsed Event

This event should be sent when user has browsed a product.

```typescript
  const custom = {"string": "text", "int": 22, "bool": true}
  NativeModules.EuvicMobile.productBrowsedEvent({
    id: "1",
    price: "10.00",
    quantity: 3,
  }, custom)
```

| Param  | Type | Description | Note |
| --- | --- | --- | --- |
| `product` | Product | represents browsed product | Required |
| `custom` | [String: Any] | represents custom data as dictionary | Optional |

### Product Added Event

This event should be sent when user adds product to the shopping cart.

```typescript
  const custom = {"string": "text", "int": 22, "bool": true}
  NativeModules.EuvicMobile.productAddedEvent({
    id: "1",
    price: "10.00",
    quantity: 3,
  }, custom)
```

| Param  | Type | Description | Note |
| --- | --- | --- | --- |
| `product` | Product | represents product added to cart | Required |
| `custom` | [String: Any] | represents custom data as dictionary | Optional |

### Product Removed Event

This event should be sent when user removes product from the shopping cart.

```typescript
  const custom = {"string": "text", "int": 22, "bool": true}
  NativeModules.EuvicMobile.productRemovedEvent({
    id: "1",
    price: "10.00",
    quantity: 3,
  }, custom)
```

| Param  | Type | Description | Note |
| --- | --- | --- | --- |
| `product` | Product | represents product removed from cart | Required |
| `custom` | [String: Any] | represents custom data as dictionary | Optional |

### Browsed Category Event

This event should be sent when user has browsed category.

```typescript
  const custom = {"string": "text", "int": 22, "bool": true}
  NativeModules.EuvicMobile.browsedCategoryEvent("some category name", [
    {
      id: "1",
      price: "10.00",
      quantity: 3,
    },
    {
      id: "33",
      price: "79.02",
      currency: "PLN",
      quantity: 13,
    }
  ], custom)
```

| Param  | Type | Description | Note |
| --- | --- | --- | --- |
| `name` | String | represents category name | Required |
| `products` | [Product] | represents array of products from the category | Required |
| `custom` | [String: Any] | represents custom data as dictionary | Optional |

### Cart Event

This event should be sent when user views products in the cart.

```typescript
  const custom = {"string": "text", "int": 22, "bool": true}
  NativeModules.EuvicMobile.cartEvent([
    {
      id: "1",
      price: "10.00",
      quantity: 3,
    },
    {
      id: "33",
      price: "79.02",
      currency: "PLN",
      quantity: 13,
    }
  ], custom)
```

| Param  | Type | Description | Note |
| --- | --- | --- | --- |
| `products` | [Product] | represents an array of products from cart | Required |
| `custom` | [String: Any] | represents custom data as dictionary | Optional |

### Order Started Event

This event should be sent when user has started the order process.

```typescript
  const custom = {"string": "text", "int": 22, "bool": true}
  NativeModules.EuvicMobile.orderStartedEvent(custom)
```

| Param  | Type | Description | Note |
| --- | --- | --- | --- |
| `custom` | [String: Any] | represents custom data as dictionary | Optional |

### Products Ordered Event

This event should be sent when user has completed the order process.

```typescript
  const custom = {"string": "text", "int": 22, "bool": true}
  NativeModules.EuvicMobile.productsOrderedEvent("order id", "89.02", [
    {
      id: "1",
      price: "10.00",
      quantity: 3,
    },
    {
      id: "33",
      price: "79.02",
      quantity: 13,
    }
  ], "EUR", custom)
```

| Param  | Type | Description | Note |
| --- | --- | --- | --- |
| `orderId` | String | represents the unique id of the order process | Required |
| `saleValue` | String | represents the value of the products user has ordered | Required |
| `products` | [Product] | represents an array of ordered products | Required |
| `currency` | String | represents the currency of the sale value. Should be a three letter value consistent with ISO 4217 norm | Optional |
| `custom` | [String: Any] | represents custom data as dictionary | Optional |


## Types

### Product

Represents a product instance

| Param  | Type | Description | Note |
| --- | --- | --- | --- |
| `id` | String | represents products unique identifier | Required |
| `price` | String | represents products value | Required |
| `currency` | String | represents products price currency | Optional |
| `quantity` | String | depending on type of event, it can represents added, removed or in basket quantity of the product | Required |
