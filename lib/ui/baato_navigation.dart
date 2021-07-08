import 'package:baato_navigation/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapbox_gl_platform_interface/mapbox_gl_platform_interface.dart';

class BaatoNavigation extends StatefulWidget {
  LatLng destinationPoint;
  BaatoNavigation(LatLng last){
    this.destinationPoint=last;
  }

  @override
  _BaatoNavigationState createState() => _BaatoNavigationState();
}

class _BaatoNavigationState extends State<BaatoNavigation> {
  String _platformVersion = 'Unknown';
  String _instruction = "";
  WayPoint _origin = WayPoint(
      name: "Way Point 1",
      latitude: 27.7172,
      longitude: 85.3240);
  final _stop1 = WayPoint(
      name: "Way Point 2",
      latitude: 27.7172,
      longitude: 86.3240);

  Navigationbaato _directions;
  MapBoxOptions _options;

  bool _arrived = false;
  bool _isMultipleStop = false;
  double _distanceRemaining, _durationRemaining;
  MapBoxNavigationViewController _controller;
  bool _routeBuilt = false;
  bool _isNavigating = false;

  @override
  Future<void> initState() {
    super.initState();
    _determinePosition();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text('Running on: $_platformVersion\n'),
                    Container(
                      color: Colors.grey,
                      width: double.infinity,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: (Text(
                          "Full Screen Navigation",
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RaisedButton(
                          child: Text("Start A to B"),
                          onPressed: () async {
                            var wayPoints = List<WayPoint>();
                            wayPoints.add(_origin);
                            wayPoints.add(_stop1);

                            await _directions.startNavigation(
                                wayPoints: wayPoints,
                                options: MapBoxOptions(
                                    mode:
                                    BaatoNavigationMode.car,
                                    simulateRoute: true,
                                    language: "en",
                                    units: VoiceUnits.metric));
                          },
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        RaisedButton(
                          child: Text("Start Multi Stop"),
                          onPressed: () async {
                            _isMultipleStop = true;
                            var wayPoints = List<WayPoint>();
                            wayPoints.add(_origin);
                            wayPoints.add(_stop1);
                            wayPoints.add(_origin);

                            await _directions.startNavigation(
                                wayPoints: wayPoints,
                                options: MapBoxOptions(
                                    mode: BaatoNavigationMode.car,
                                    simulateRoute: true,
                                    language: "en",
                                    allowsUTurnAtWayPoints: true,
                                    units: VoiceUnits.metric));
                          },
                        )
                      ],
                    ),
                    Container(
                      color: Colors.grey,
                      width: double.infinity,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: (Text(
                          "Embedded Navigation",
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RaisedButton(
                          child: Text(_routeBuilt && !_isNavigating
                              ? "Clear Route"
                              : "Build Route"),
                          onPressed: _isNavigating
                              ? null
                              : () {
                            if (_routeBuilt) {
                              _controller.clearRoute();
                            } else {
                              var wayPoints = List<WayPoint>();
                              wayPoints.add(_origin);
                              wayPoints.add(_stop1);
                              wayPoints.add(_origin);
                              _isMultipleStop = wayPoints.length > 2;
                              _controller.buildRoute(
                                  wayPoints: wayPoints);
                            }
                          },
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        RaisedButton(
                          child: Text("Start "),
                          onPressed: _routeBuilt && !_isNavigating
                              ? () {
                            _controller.startNavigation();
                          }
                              : null,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        RaisedButton(
                          child: Text("Cancel "),
                          onPressed: _isNavigating
                              ? () {
                            _controller.finishNavigation();
                          }
                              : null,
                        )
                      ],
                    ),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "Long-Press Embedded Map to Set Destination",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.grey,
                      width: double.infinity,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: (Text(
                          _instruction == null || _instruction.isEmpty
                              ? "Banner Instruction Here"
                              : _instruction,
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 20.0, right: 20, top: 20, bottom: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text("Duration Remaining: "),
                              Text(_durationRemaining != null
                                  ? "${(_durationRemaining / 60).toStringAsFixed(0)} minutes"
                                  : "---")
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text("Distance Remaining: "),
                              Text(_distanceRemaining != null
                                  ? "${(_distanceRemaining * 0.000621371).toStringAsFixed(1)} miles"
                                  : "---")
                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider()
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.grey,
                child: MapBoxNavigationView(
                    options: _options,
                    onRouteEvent: _onEmbeddedRouteEvent,
                    onCreated:
                        (MapBoxNavigationViewController controller) async {
                      _controller = controller;
                      controller.initialize();
                    }),
              ),
            )
          ]),
        ),
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    print('service enabled $serviceEnabled');
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      print('Location services are disabled.');
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      print(
          'Location permissions are permanently denied, we cannot request permissions.');
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    var position = await Geolocator.getCurrentPosition();
    this.setState(() {
      _origin = WayPoint(
          name: "Way Point 1",
          latitude: position.latitude,
          longitude: position.longitude);
    });
    initialize(position.latitude, position.longitude);
    return position;
  }
// Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initialize(double latitude, double longitude) async {
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    print('initialize ');
    _directions = Navigationbaato(onRouteEvent: _onEmbeddedRouteEvent);
    _options = MapBoxOptions(
      initialLatitude: _origin.latitude,
      initialLongitude: _origin.longitude,
      zoom: 15.0,
      tilt: 0.0,
      bearing: 0.0,
      enableRefresh: false,
      alternatives: true,
      voiceInstructionsEnabled: true,
      bannerInstructionsEnabled: true,
      allowsUTurnAtWayPoints: true,
      mode: BaatoNavigationMode.car,
      units: VoiceUnits.imperial,
      simulateRoute: false,
      animateBuildRoute: true,
      longPressDestinationEnabled: true,
      mapStyleUrl: "https://api.baato.io/api/v1/styles/breeze",
      language: "ne",
    );
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await _directions.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    setState(() {
      _platformVersion = platformVersion;
    });

    //build navigation
    // callNavigationSDK();
  }

  Future<void> callNavigationSDK() async {
    List<WayPoint> wayPoints = [];
    wayPoints.add(_origin);
    final destination = WayPoint(
        name: "Way Point 2",
        latitude: widget.destinationPoint.latitude,
        longitude: widget.destinationPoint.longitude);
    wayPoints.add(destination);

    _controller.initialize();
    _controller.buildRoute(wayPoints: wayPoints,options: MapBoxOptions(
        mode:
        BaatoNavigationMode.car,
        simulateRoute: true,
        language: "en",
        units: VoiceUnits.metric));

    // await _directions.startNavigation(
    //     wayPoints: wayPoints,
    //     options: MapBoxOptions(
    //         mode:
    //         BaatoNavigationMode.car,
    //         simulateRoute: true,
    //         language: "en",
    //         units: VoiceUnits.metric));
  }

  Future<void> _onEmbeddedRouteEvent(e) async {
    _distanceRemaining = await _directions.distanceRemaining;
    _durationRemaining = await _directions.durationRemaining;
    print("embedded royre");
    switch (e.eventType) {
      case MapBoxEvent.progress_change:
        print('progress');
        var progressEvent = e.data as RouteProgressEvent;
        _arrived = progressEvent.arrived;
        if (progressEvent.currentStepInstruction != null)
          _instruction = progressEvent.currentStepInstruction;
        break;
      case MapBoxEvent.route_building:
      case MapBoxEvent.route_built:
        print('rpute built');
        setState(() {
          _routeBuilt = true;
        });
        break;
      case MapBoxEvent.route_build_failed:
        setState(() {
          _routeBuilt = false;
        });
        break;
      case MapBoxEvent.navigation_running:
        print('rpute navigation running');
        setState(() {
          _isNavigating = true;
        });
        break;
      case MapBoxEvent.on_arrival:
        _arrived = true;
        if (!_isMultipleStop) {
          await Future.delayed(Duration(seconds: 3));
          await _controller.finishNavigation();
        } else {}
        break;
      case MapBoxEvent.navigation_finished:
      case MapBoxEvent.navigation_cancelled:
        setState(() {
          _routeBuilt = false;
          _isNavigating = false;
        });
        break;
      default:
        break;
    }
    setState(() {});
  }
}
