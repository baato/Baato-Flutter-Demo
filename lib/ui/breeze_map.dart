import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class BreezeMapStyle extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  MapboxMapController mapController;

  void _onMapCreated(MapboxMapController controller) {
    this.mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    /*Please add your baato-access-token to load map*/
    String baatoAccessToken="your-baato-access-token";
    String mapStyle="breeze";
    return new Scaffold(
        appBar: AppBar(
          title: Text('Baato Breeze Map'),
          backgroundColor: Color.fromRGBO(8, 30, 42, 50),
        ),
        body: MapboxMap(
          accessToken: '',
          onMapCreated: _onMapCreated,
          initialCameraPosition: const CameraPosition(
              target: LatLng(27.7192873, 85.3238007), zoom: 14.0),
          styleString:
              "https://api.baato.io/api/v1/styles/"+mapStyle+"?key="+baatoAccessToken,
        )
    );
  }
}
