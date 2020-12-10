import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import '../main.dart';

class MonochromeMapStyle extends StatelessWidget {
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
    String baatoAccessToken = BaatoExampleApp.BAATO_ACCESS_TOKEN;
    String mapStyle="monochrome";
    return new Scaffold(
        appBar: AppBar(
          title: Text('Baato Monochrome Map'),
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
