# Fetch Weather - Step 1: Setting up the environment

In this step, we will set up the destination to access the external weather API.

## Preview

![image](assets/preview.png)

*The Weather destination is configured in your BTP account*

## Prerequisite
- You have set up Joule on your BTP account and installed the Joule tools [see Hello World - Step 1](../../helloworld/step1/index.md)

## Steps

### Create Weather Destination

To access the external weather API, we need to configure a destination in your BTP account.

1. Go to your SAP BTP global account and navigate to `Connectivity` > `Destinations`.
2. Press on `New Destination` and fill in the following information:

```properties
URL=https://api.weather.com/v3
Name=WEATHER
ProxyType=Internet
Type=HTTP
Authentication=NoAuthentication
```
3. Press on "New Property" to add the property `URL.queries.apiKey` with value `c322ef22435d40bfa2ef22435df0bfbe`. This will automatically add the API Key as additional query parameter to all API calls.

* [Back to Overview](../index.md)
* [Continue with Step 2](../step2/index.md)

## Related Information 

[HTTP Destinations](https://help.sap.com/docs/connectivity/sap-btp-connectivity-cf/http-destinations)
