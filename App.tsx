/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * Generated with the TypeScript template
 * https://github.com/react-native-community/react-native-template-typescript
 *
 * @format
 */

import React, {type PropsWithChildren} from 'react';
import { Buffer } from 'buffer';
import {
  Button,
  SafeAreaView,
  ScrollView,
  StatusBar,
  StyleSheet,
  Text,
  useColorScheme,
  View,
  NativeModules,
  Linking,
  Platform,
  PermissionsAndroid,
  Permission
} from 'react-native';

import Geolocation from 'react-native-geolocation-service';
import { requestTrackingPermission } from 'react-native-tracking-transparency';

import {
  Colors
} from 'react-native/Libraries/NewAppScreen';

const Section: React.FC<
  PropsWithChildren<{
    title: string;
  }>
> = ({children, title}) => {
  const isDarkMode = useColorScheme() === 'dark';
  return (
    <View style={styles.sectionContainer}>
      <Text
        style={[
          styles.sectionTitle,
          {
            color: isDarkMode ? Colors.white : Colors.black,
          },
        ]}>
        {title}
      </Text>
      <Text
        style={[
          styles.sectionDescription,
          {
            color: isDarkMode ? Colors.light : Colors.dark,
          },
        ]}>
        {children}
      </Text>
    </View>
  );
};

 const AskPermission = async (permission: Permission) => {
  try {
    await PermissionsAndroid.request(permission);
  } catch (err) {
    console.warn(err);
  }
};

const App = () => {
  const sdk = NativeModules.EuvicMobile;
  sdk.configure('https://delivery.clickonometrics.pl/tracker=multi/track/multi/track.json', 'zGvjBvroFc7onruVlmSoy3foBHLG4Upq', null, null, true);

  if (Platform.OS === 'android') AskPermission(PermissionsAndroid.PERMISSIONS.ACCESS_FINE_LOCATION);
  if (Platform.OS === 'ios') Geolocation.requestAuthorization('whenInUse');

  const trackingStatus = requestTrackingPermission();

  const isDarkMode = useColorScheme() === 'dark';

  const backgroundStyle = {
    backgroundColor: isDarkMode ? Colors.darker : Colors.lighter,
  };

  return (
    <SafeAreaView style={backgroundStyle}>
      <StatusBar
        barStyle={isDarkMode ? 'light-content' : 'dark-content'}
        backgroundColor={backgroundStyle.backgroundColor}
      />
      <ScrollView
        contentInsetAdjustmentBehavior="automatic"
        style={backgroundStyle}>
        <View
          style={{
            backgroundColor: isDarkMode ? Colors.black : Colors.white,
          }}>
          <Text  style={{ fontSize: 30, paddingVertical: 40 }}>Euvic Mobile SKD</Text>
          <Button title='Homepage visited' onPress={() => homePageVisitedEvent() }></Button>
          <Button title='Product browsed' onPress={() => productBrowsedEvent() }></Button>
          <Button title='Product added' onPress={() => productAddedEvent() }></Button>
          <Button title='Product removed' onPress={() => productRemovedEvent() }></Button>
          <Button title='Browsed category' onPress={() => browsedCategoryEvent() }></Button>
          <Button title='Cart' onPress={() => cartEvent() }></Button>
          <Button title='Order started' onPress={() => orderStartedEvent() }></Button>
          <Button title='Products ordered' onPress={() => productsOrderedEvent() }></Button>
          <Button title='Show Ad' onPress={() => showBrowser() }></Button>
        </View>
      </ScrollView>
    </SafeAreaView>
  );
};

function homePageVisitedEvent() {
  const custom = {"string": "text", "int": 22, "bool": true}
  NativeModules.EuvicMobile.homepageVisitedEvent(custom)
}

function productBrowsedEvent() {
  const custom = {"string": "text", "int": 22, "bool": true}
  NativeModules.EuvicMobile.productBrowsedEvent({
    id: "1",
    price: "10.00",
    quantity: 3,
  }, custom)
}

function productAddedEvent() {
  const custom = {"string": "text", "int": 22, "bool": true}
  NativeModules.EuvicMobile.productAddedEvent({
    id: "1",
    price: "10.00",
    quantity: 3,
  }, custom)
}

function productRemovedEvent() {
  const custom = {"string": "text", "int": 22, "bool": true}
  NativeModules.EuvicMobile.productRemovedEvent({
    id: "1",
    price: "10.00",
    quantity: 3,
  }, custom)
}

function browsedCategoryEvent() {
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
}

function cartEvent() {
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
}

function orderStartedEvent() {
  const custom = {"string": "text", "int": 22, "bool": true}
  NativeModules.EuvicMobile.orderStartedEvent(custom)
}

function productsOrderedEvent() {
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
}

function showBrowser() {
  NativeModules.EuvicMobile.getCurrentUserId( (value: string) =>  {
    const userId = Buffer.from(value, 'utf-8').toString('base64')
    const userType = Platform.OS === 'ios' ? 'IDFA' : 'AAID' 
    Linking.openURL("https://static.clickonometrics.pl/previews/campaignsPreview.html?key=zGvjBvroFc7onruVlmSoy3foBHLG4Upq&user_id=" + userId + "&user_type=" + userType)
  })
}

const styles = StyleSheet.create({
  sectionContainer: {
    marginTop: 32,
    paddingHorizontal: 24,
  },
  sectionTitle: {
    fontSize: 24,
    fontWeight: '600',
  },
  sectionDescription: {
    marginTop: 8,
    fontSize: 18,
    fontWeight: '400',
  },
  highlight: {
    fontWeight: '700',
  },
});

export default App;
