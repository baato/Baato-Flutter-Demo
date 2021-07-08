import 'package:baato_api/baato_api.dart';
import 'package:baato_api/models/place.dart';
import 'package:baato_api/models/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/utils.dart';
import 'package:flutter_app/ui/baato_navigation.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import '../main.dart';

class BaatoDirectionsExample extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Baato Directions"),
          backgroundColor: Color.fromRGBO(8, 30, 42, 50),
        ),
        body: BaatoDirectionsPage(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class BaatoDirectionsPage extends StatefulWidget {
  @override
  _BaatoDirectionsPageState createState() => _BaatoDirectionsPageState();
}

class _BaatoDirectionsPageState extends State<BaatoDirectionsPage> {
  MapboxMapController mapController;
  RouteResponse routeResponse;
  int _circleCount = 0;

  String baatoAccessToken = BaatoExampleApp.BAATO_ACCESS_TOKEN;
  List<LatLng> _points = [];

  void _onMapCreated(MapboxMapController controller) {
    this.mapController = controller;

    //show initial information
    final snackBar = SnackBar(
      content: Text(
        "Tap on any two points in the map to get routes between them... ",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      duration: Duration(seconds: 12),
    );

    // Find the Scaffold in the widget tree and use it to show a SnackBar.
    Scaffold.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    /*map style can be 'retro','breeze','monochrome'*/
    String mapStyle = "breeze";
    return new Scaffold(
        body: MapboxMap(
      accessToken: '',
      onMapCreated: _onMapCreated,
      onMapClick: (point, latLng) async {
        _addTappedPointToPointsList(context, latLng);
      },
      initialCameraPosition: const CameraPosition(
          target: LatLng(27.7192873, 85.3238007), zoom: 14.0),
      styleString: "https://api.baato.io/api/v1/styles/" +
          mapStyle +
          "?key=" +
          baatoAccessToken,
    ));
  }

  _requestRoutingDetails(BuildContext context, List<LatLng> latLngList) async {
    var points = [];
    for (LatLng latLng in latLngList)
      points
          .add(latLng.latitude.toString() + "," + latLng.longitude.toString());

    BaatoRoute baatoRoute = BaatoRoute.initialize(
        accessToken: baatoAccessToken,
        points: points,
        mode: "car", //can be 'bike', 'car', 'foot'
        alternatives: false, //optional parameter
        instructions: false); //optional parameter

    //get routes between start and destination point
    RouteResponse response = await baatoRoute.getRoutes();
    setState(() {
      routeResponse = response;
    });
    _showRouteDetails(response);
  }

  _showRouteDetails(RouteResponse response) {
    if (response == null || response.data.isEmpty)
      print("No result found");
    else {
      //decode the encoded polyline
      List<GeoCoord> geoCoordinates =
          BaatoUtils().decodeEncodedPolyline(response.data[0].encodedPolyline);

      //convert the list into list of LatLng to be used by Mapbox
      List<LatLng> latLngList = <LatLng>[];
      for (GeoCoord geoCoord in geoCoordinates)
        latLngList.add(new LatLng(geoCoord.lat, geoCoord.lon));

      //show routes from the points decoded
      mapController.clearLines();
      mapController.addLine(
        LineOptions(
            geometry: latLngList,
            lineColor: "#081E2A",
            lineWidth: 10.0,
            lineOpacity: 0.5),
      );

      double distanceInKm = response.data[0].distanceInMeters / 1000;
      distanceInKm = double.parse((distanceInKm).toStringAsFixed(2));

      double timeInSeconds = response.data[0].timeInMs / 1000;
      String displayTime =
          Utils().giveMeTimeFromSecondsFormat(timeInSeconds.toInt());

      //create a snack bar to show more details of the route
      final snackBar = SnackBar(
        content: Text(
          "Distance: " +
              distanceInKm.toString() +
              " km\n" +
              "Time: " +
              displayTime,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        action: SnackBarAction(
          label: 'Start',
          onPressed: () {
            // Some code to undo the change.
            if(_points.isNotEmpty&&_points.length!=1)
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => BaatoNavigation(_points.last)));
            else
              print("no destination selected points size ${_points.length}");
          },
        ),
        duration: Duration(seconds: 10),
      );

      // Find the Scaffold in the widget tree and use it to show a SnackBar.
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  void _addTappedPointToPointsList(BuildContext context, LatLng latLng) {
    if (_circleCount < 2) {
      _addCircle(latLng);
      _circleCount++;
      _points.add(latLng);
      if (_circleCount == 2) _requestRoutingDetails(context, _points);
    } else {
      mapController.clearCircles();
      mapController.clearLines();
      _circleCount = 0;
      _points = <LatLng>[];
      _addTappedPointToPointsList(context, latLng);
    }
  }

  // add circle layer to indicate start and destination points
  void _addCircle(LatLng latLng) {
    String circleColor = "#081E2A";
    if (_circleCount == 1) circleColor = "#63A088";
    mapController.addCircle(
      CircleOptions(
          geometry: latLng,
          circleColor: circleColor,
          circleRadius: 10.0,
          circleStrokeColor: '#757575',
          circleStrokeWidth: 5.0),
    );
  }
}
