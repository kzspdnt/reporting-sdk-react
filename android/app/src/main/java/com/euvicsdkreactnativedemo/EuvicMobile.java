package com.euvicsdkreactnativedemo;

import android.content.Context;

import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;

import org.jetbrains.annotations.NotNull;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kotlin.Unit;
import kotlin.jvm.functions.Function1;
import pl.speednet.euvictrackersdk.EuvicMobileSDK;
import pl.speednet.euvictrackersdk.events.CustomParams;
import pl.speednet.euvictrackersdk.events.Product;

public class EuvicMobile extends ReactContextBaseJavaModule {

    EuvicMobile(ReactApplicationContext context) {
        super(context);
    }

    @Override
    public String getName() {
        return "EuvicMobile";
    }

    EuvicMobileSDK sdk = EuvicMobileSDK.INSTANCE;

    @ReactMethod
    public void configure(
            String url,
            String apiKey,
            String userId,
            String currency,
            Boolean allowSensitiveData
    ) {
        Context context = getReactApplicationContext();

        sdk.configure(
                context,
                url,
                apiKey,
                userId,
                currency,
                allowSensitiveData

        );
    }

    @ReactMethod
    public void getCurrentUserId(Callback callBack) {
        try {
            String userId = sdk.getGetCurrentUserId();
            callBack.invoke(userId);
        } catch (Exception ignored) {

        }
    }

    @ReactMethod
    public void homepageVisitedEvent(ReadableMap custom) {
        sdk.homepageVisitedEvent(mapToCustomParams(custom));
    }

    @ReactMethod
    public void productBrowsedEvent(ReadableMap product, ReadableMap custom) {
        Product productObject = mapToProduct(product.toHashMap());
        if (productObject != null) {
            sdk.productBrowsedEvent(
                    productObject,
                    mapToCustomParams(custom)
            );
        }
    }

    @ReactMethod
    public void productAddedEvent(ReadableMap product, ReadableMap custom) {
        Product productObject = mapToProduct(product.toHashMap());
        if (productObject != null) {
            sdk.productAddedEvent(
                    mapToProduct(product.toHashMap()),
                    mapToCustomParams(custom)
            );
        }
    }

    @ReactMethod
    public void productRemovedEvent(ReadableMap product, ReadableMap custom) {
        Product productObject = mapToProduct(product.toHashMap());
        if (productObject != null) {
            sdk.productRemovedEvent(
                    productObject,
                    mapToCustomParams(custom)
            );
        }
    }

    @ReactMethod
    public void browsedCategoryEvent(String categoryName, ReadableArray products, ReadableMap custom) {
        List<Product> productList = mapToProductList(products.toArrayList());

        if (!productList.isEmpty()) {
            sdk.browsedCategoryEvent(
                    categoryName,
                    productList,
                    mapToCustomParams(custom)
            );
        }
    }

    @ReactMethod
    public void cartEvent(ReadableArray products, ReadableMap custom) {
        List<Product> productList = mapToProductList(products.toArrayList());

        if (!productList.isEmpty()) {
            sdk.cartEvent(
                    productList,
                    mapToCustomParams(custom)
            );
        }
    }

    @ReactMethod
    public void orderStartedEvent(ReadableMap custom) {
        sdk.orderStartedEvent(
                mapToCustomParams(custom)
        );
    }

    @ReactMethod
    public void productsOrderedEvent(String orderId, String saleValue, ReadableArray products, String currency, ReadableMap custom) {
        List<Product> productList = mapToProductList(products.toArrayList());

        sdk.productsOrderedEvent(
                orderId,
                saleValue,
                productList,
                currency,
                mapToCustomParams(custom)
        );
    }

    private List<Product> mapToProductList(List<Object> productsArrayList) {

        List<Product> productList;

        if (productsArrayList != null) {
            ArrayList<Product> mutableList = new ArrayList<>();

            for (Object element : (Iterable<Object>) productsArrayList) {
                HashMap<String, Object> hashProduct = (HashMap) element;

                Product getProduct = mapToProduct((HashMap) hashProduct);

                if (getProduct != null) {
                    mutableList.add(getProduct);
                }
            }
            productList = mutableList;
        } else {
            productList = null;
        }

        return productList;
    }

    private Product mapToProduct(HashMap<String, Object> map) {
        try {

            Object id = map.get("id");
            if (!(id instanceof String)) {
                id = null;
            }

            Object price = map.get("price");
            if (!(price instanceof String)) {
                price = null;
            }

            Object currency = map.get("currency");
            if (!(currency instanceof String)) {
                currency = null;
            }

            Object quantity = map.get("quantity");
            if (!(quantity instanceof Integer)) {
                if (quantity instanceof Double) {
                    long longQuantity = Math.round((Double) quantity);
                    quantity = Math.toIntExact(longQuantity);
                } else if (quantity instanceof Long) {
                    quantity = Math.toIntExact((Long) quantity);
                } else {
                    quantity = null;
                }
            }


            Product product;
            if (id != null && price != null && quantity != null) {

                if (currency != null) {
                    product = new Product(id.toString(), price.toString(), currency.toString(), (int) quantity);
                } else {
                    product = new Product(id.toString(), price.toString(), null, (int) quantity);
                }

            } else {
                product = null;
            }
            return product;
        } catch (Exception e) {

        }
        return null;
    }

    private Function1 mapToCustomParams(final ReadableMap map) {
        return map == null || map.toHashMap().isEmpty() ? null : (Function1) (new Function1() {
            public Object invoke(Object object) {
                this.invoke((CustomParams) object);
                return Unit.INSTANCE;
            }

            public void invoke(@NotNull CustomParams receiver) {
                Map<String, Object> hashMap = map.toHashMap();

                for (Map.Entry<String, Object> stringObjectEntry : hashMap.entrySet()) {

                    String key = (String) ((Map.Entry<String, Object>) stringObjectEntry).getKey();
                    Object value = ((Map.Entry<String, Object>) stringObjectEntry).getValue();

                    if (value instanceof String) {
                        receiver.param(key, (String) value);
                    } else if (value instanceof Integer) {
                        receiver.param(key, ((Number) value).intValue());
                    } else if (value instanceof Float) {
                        receiver.param(key, ((Number) value).floatValue());
                    } else if (value instanceof Double) {
                        receiver.param(key, ((Number) value).doubleValue());
                    } else if (value instanceof Boolean) {
                        receiver.param(key, ((Boolean) value).toString());
                    }
                }

            }
        });
    }

}