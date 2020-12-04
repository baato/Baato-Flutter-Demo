import 'package:baato_api/baato_api.dart';
import 'package:baato_api/models/place.dart';
import 'package:flutter/material.dart';
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
  MapboxMapController mapController;
  PlaceResponse placeResponse;

  void _onMapCreated(MapboxMapController controller) {
    this.mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    /*map style can be 'retro','breeze','monochrome'*/
    /*Please add your baato-access-token to load map*/
    String baatoAccessToken="your-baato-access-token";
    String mapStyle = "retro";

    return new Scaffold(
        body: MapboxMap(
      accessToken: '',
      onMapCreated: _onMapCreated,
      onMapClick: (point, latLng) async {
        print("Map click: ${point.x},${point.y}   ${latLng.latitude}/${latLng.longitude}");
        mapController.moveCamera(
          CameraUpdate.newLatLng(
            latLng,
          ),
        );
        _requestLocationDetails(context, latLng,baatoAccessToken);
      },
      initialCameraPosition: const CameraPosition(
          target: LatLng(27.7192873, 85.3238007), zoom: 14.0),
          styleString: "https://api.baato.io/api/v1/styles/" + mapStyle + "?key=" + baatoAccessToken,
    ));
  }

  _requestLocationDetails(BuildContext context, LatLng latLng, String baatoAccessToken) async {
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

    mapController.clearCircles();
    mapController.addCircle(
      CircleOptions(
          geometry: latLng,
          circleColor: "#081E2A",
          circleRadius: 10.0,
          circleStrokeColor: '#757575',
          circleStrokeWidth: 5.0),
    );

    _showAddressInfo(response);
  }

  _showAddressInfo(PlaceResponse response) {
    if (response == null || response.data.isEmpty)
      print("No result found");
    else {
      final snackBar = SnackBar(
          content: Text(
        response.data[0].name + "\n" + response.data[0].address,
        style: TextStyle(fontWeight: FontWeight.bold),
      ));

      // Find the Scaffold in the widget tree and use it to show a SnackBar.
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }
}
