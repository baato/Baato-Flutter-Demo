# baato-flutter-demo

This is a public demo of the Baato App for Flutter. This app shows the way to integrate [Baato](http://baato.io/) map style in flutter using Mapbox.

### Running locally

#### 1. Setting the Baato access token
This demo app requires a Baato account and a Baato access token. Obtain your access token on the [Baato account page](http://baato.io/). Paste your access token in the line below in `main.dart` file .

```
 static const String BAATO_ACCESS_TOKEN = "your-baato-access-token";
```
### Note!
If you encounter issue like `Could not get unknown property 'android' for project ':mapbox_gl' of type org.gradle.api.Project. `
you can solve the issue as mentioned here in the [comment](https://github.com/tobrun/flutter-mapbox-gl/issues/640#issuecomment-859685096) or follow the steps mentioned in the **Android Configuration** section below:

## Android Configuration For Windows

1. Go to your [Mapbox account dashboard](https://account.mapbox.com/) and create an access token that has the `DOWNLOADS:READ` scope. **PLEASE NOTE: This is not the same as your production Mapbox API token.
2. Set the System environment variable SDK_REGISTRY_TOKEN with the value of the private token taken from mapbox web page . Add for both System variables and User variable. Then restart the PC.
3. Add the following code snippet into your module-level build.gradle where all the dependencies are defined. And build your app.
```code
    def token = System.getenv('SDK_REGISTRY_TOKEN')
    if (token == null || token.empty) {
        throw new Exception("SDK Registry token is null. See README.md for more information.")
    }
```
4. Voila! You are good to go.
