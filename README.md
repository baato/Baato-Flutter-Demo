# baato-flutter-demo

This is a public demo of the Baato App for Flutter. This app shows the way to integrate [Baato](http://baato.io/) map style in flutter using Mapbox.

### Running locally

#### 1. Setting the Baato access token
This demo app requires a Baato account and a Baato access token. Obtain your access token on the [Baato account page](http://baato.io/). Paste your access token in the line below in `main.dart` file .

```
 static const String BAATO_ACCESS_TOKEN = "your-baato-access-token";
```
### Note!
If you encounter issue like `Could not get unknown property 'android' for project ':mapbox_gl' of type org.gradle.api.Project.` or `SDK Registry token is null. See README.md for more information.` you can solve the issue as mentioned here in the [comment](https://github.com/tobrun/flutter-mapbox-gl/issues/640#issuecomment-857649226) or follow the steps mentioned in the **Android Configuration** section below:

## Android Configuration For Windows 

1. Go to your [Mapbox account dashboard](https://account.mapbox.com/) and create an access token that has the `DOWNLOADS:READ` scope. **PLEASE NOTE: This is not the same as your production Mapbox API token. Make sure to keep it private and do not insert it into strings.xml.**
2. Set the System environment variable SDK_REGISTRY_TOKEN with the value of the private token taken from mapbox web page . Add for both System variables and User variable. Then restart the PC.
3. Add the following code snippet into your module-level build.gradle where all the dependencies are defined. And build your app.
```code
    def token = System.getenv('SDK_REGISTRY_TOKEN')
    if (token == null || token.empty) {
        throw new Exception("SDK Registry token is null. See README.md for more information.")
    }
```
4. Voila! You are good to go.

## iOS and Android Configuration For Mac

1. Go to your [Mapbox account dashboard](https://account.mapbox.com/) and create an access token that has the `DOWNLOADS:READ` scope. **PLEASE NOTE: This is not the same as your production Mapbox API token. Make sure to keep it private and do not insert it into any Info.plist file.** Create a file named `.netrc` in your home directory if it doesn’t already exist:
   ##### To create .netrc file
     ```
     touch .netrc
     open .netrc
     ```
     ##### Now, add the following lines to the file
     ```
     machine api.mapbox.com
     login mapbox
     password PRIVATE_MAPBOX_API_TOKEN
     ```
     where _PRIVATE_MAPBOX_API_TOKEN_ is your Mapbox API token with the `DOWNLOADS:READ` scope.
2. Set the System environment variable SDK_REGISTRY_TOKEN with the value of the private token taken from mapbox web page . If you are confused with setting environment variable in Mac, please follow the steps mentioned in the **Setting env variables in Mac** below. Then restart the PC.
3. Some iOS version also require location settings in default, for that goto your `Info.plist file` and set `NSLocationWhenInUseUsageDescription` to:

   > Shows your location on the map and helps improve OpenStreetMap.
4. To build on Android, add the following code snippet into your module-level build.gradle where all the dependencies are defined. And build your app.
```code
    def token = System.getenv('SDK_REGISTRY_TOKEN')
    if (token == null || token.empty) {
        throw new Exception("SDK Registry token is null. See README.md for more information.")
    }
```
5. Voila! You are good to go.

### Note!
If you are getting issue with building in simulator, related to arm64 architecture, add the following lines into your `ios>Podfile` installer code block:
## Existing
```
post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
  end
end
```
## Updated
```
post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
  end
  installer.pods_project.build_configurations.each do |config|
      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
  end
end
```
## Setting env variables in Mac

1. Open Terminal
2. Run touch ~/.bash_profile; open ~/.bash_profile
3. In TextEdit, add  ```export SDK_REGISTRY_TOKEN="sk.tygkisdsosiosisoispfsppsofisopisospisopsifsofsofspo"```. Please add the token you that you got from above steps.
4. Save the .bash_profile file and Quit (Command + Q) Text Edit.
5. Run source ~/.bash_profile

For more info: https://hathaway.cc/2008/06/how-to-edit-your-path-environment-variables-on-mac/
