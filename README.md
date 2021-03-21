# baato-flutter-demo

This is a public demo of the Baato App for Flutter. This app shows the way to integrate [Baato](http://baato.io/) map style in flutter using Mapbox.

### Running locally

#### 1. Setting the Baato access token
This demo app requires a Baato account and a Baato access token. Obtain your access token on the [Baato account page](http://baato.io/). Paste your access token in the line below in `main.dart` file .

```
 static const String BAATO_ACCESS_TOKEN = "your-baato-access-token";
```

#### Built With

* [Mapbox](https://www.mapbox.com/) - Used maps sdk to load our baato map styles.
