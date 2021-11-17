import 'dart:typed_data';

import 'package:baato_api/baato_api.dart';
import 'package:baato_api/models/place.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/main.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class BaatoLocationPickerExample extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Baato Location Picker Example"),
          backgroundColor: Color.fromRGBO(8, 30, 42, 50),
        ),
        body: BaatoReversePage(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class BaatoReversePage extends StatefulWidget {
  @override
  _BaatoReversePageState createState() => _BaatoReversePageState();
}

class _BaatoReversePageState extends State<BaatoReversePage> {
  late MapboxMapController mapController;
  PlaceResponse? placeResponse;
  bool isCameraMoving = false;

  void _onMapCreated(MapboxMapController controller) {
    this.mapController = controller;
    //show initial information
    final snackBar = SnackBar(
      content: Text(
        "Move the map to change the marker location and get location details of that point... ",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      duration: Duration(seconds: 5),
    );

    // Find the Scaffold in the widget tree and use it to show a SnackBar.
    Scaffold.of(context).showSnackBar(snackBar);
    mapController.addListener(() {
      if (mapController.isCameraMoving && mapController.symbols.isNotEmpty)
        mapController.removeSymbol(mapController.symbols.first);
      setState(() {
        isCameraMoving = mapController.isCameraMoving;
      });
    });
  }

  void _onCameraIdle() {
    if (!mapController.isCameraMoving) {
      _requestLocationDetails(context, mapController.cameraPosition!.target,
          BaatoExampleApp.BAATO_ACCESS_TOKEN);
      _showMarkerOntheTappedLocation(mapController.cameraPosition!.target);
    }
  }

  /// Adds an asset image to the currently displayed style
  Future<void> addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return mapController.addImage(name, list);
  }

  @override
  Widget build(BuildContext context) {
    /*map style can be 'retro','breeze','monochrome'*/
    String baatoAccessToken = BaatoExampleApp.BAATO_ACCESS_TOKEN;
    String mapStyle = "retro";

    return new Scaffold(
      body: Stack(children: [
        MapboxMap(
          accessToken: '',
          trackCameraPosition: true,
          onMapCreated: _onMapCreated,
          onCameraIdle: _onCameraIdle,
          onMapClick: (point, latLng) async {
            mapController.moveCamera(
              CameraUpdate.newLatLng(
                latLng,
              ),
            );
            _requestLocationDetails(context, latLng, baatoAccessToken);
            _showMarkerOntheTappedLocation(latLng);
          },
          initialCameraPosition: const CameraPosition(
              target: LatLng(27.7192873, 85.3238007), zoom: 14.0),
          styleString: "https://api.baato.io/api/v1/styles/" +
              mapStyle +
              "?key=" +
              baatoAccessToken,
        ),
        Center(
          child: Container(
              child: isCameraMoving
                  ? Image.asset('assets/images/ic_marker.png')
                  : null),
        ),
      ]),
    );
  }

  _requestLocationDetails(
      BuildContext context, LatLng latLng, String baatoAccessToken) async {
    BaatoReverse baatoReverse = BaatoReverse.initialize(
      latLon: GeoCoord(latLng.latitude, latLng.longitude),
      accessToken: baatoAccessToken,
    );

    //perform reverse Search
    PlaceResponse response = await baatoReverse.reverseGeocode();
    print(response);

    setState(() {
      placeResponse = response;
    });

    _showAddressInfo(response);
  }

  _showAddressInfo(PlaceResponse response) {
    if (response == null || response.data!.isEmpty)
      print("No result found");
    else {
      final snackBar = SnackBar(
          content: Text(
        response.data![0].name! + "\n" + response.data![0].address!,
        style: TextStyle(fontWeight: FontWeight.bold),
      ));

      // Find the Scaffold in the widget tree and use it to show a SnackBar.
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  void _showMarkerOntheTappedLocation(LatLng latLng) {
    if (mapController.symbols.isNotEmpty)
      mapController.removeSymbol(mapController.symbols.first);
    mapController.addSymbol(
      new SymbolOptions(
        geometry: latLng,
        iconImage: "assets/images/ic_marker.png",
      ),
    );
  }
}
