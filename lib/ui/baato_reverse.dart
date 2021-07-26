import 'dart:typed_data';

import 'package:baato_api/baato_api.dart';
import 'package:baato_api/models/place.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/main.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class BaatoReverseExample extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Baato Reverse"),
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

  void _onMapCreated(MapboxMapController controller) {
    this.mapController = controller;

    //show initial information
    final snackBar = SnackBar(
      content: Text(
        "Tap on any point on the map to get location details of that point... ",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      duration: Duration(seconds: 12),
    );

    // Find the Scaffold in the widget tree and use it to show a SnackBar.
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void _onStyleLoaded() {
    // addImageFromAsset("assetImage", "assets/symbols/placeholder.png");
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
      body: MapboxMap(
        accessToken: '',
        onMapCreated: _onMapCreated,
        onStyleLoadedCallback: _onStyleLoaded,
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
        styleString: "https://api.baato.io/api/v1/styles/" + mapStyle + "?key=" + baatoAccessToken,
      ),
    );
  }

  _requestLocationDetails(BuildContext context, LatLng latLng,
      String baatoAccessToken) async {
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
