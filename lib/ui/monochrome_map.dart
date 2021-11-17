import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math';
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
  MapboxMapController? mapController;

  void _onMapCreated(MapboxMapController controller) {
    this.mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    String baatoAccessToken = BaatoExampleApp.BAATO_ACCESS_TOKEN;
    String mapStyle = "monochrome";
    return new Scaffold(
        appBar: AppBar(
          title: Text('Baato Monochrome Map'),
          backgroundColor: Color.fromRGBO(8, 30, 42, 50),
        ),
        body: Stack(children: [
          MapboxMap(
            logoViewMargins: Point(-50, -50),
            accessToken: '',
            onMapCreated: _onMapCreated,
            initialCameraPosition: const CameraPosition(
                target: LatLng(27.7192873, 85.3238007), zoom: 14.0),
            styleString: "https://api.baato.io/api/v1/styles/" + mapStyle + "?key=" + baatoAccessToken,
          ),
          Align(
            child: Container(
              child: SizedBox(
                height: 35.0,
                child: Container(
                  decoration: BoxDecoration(color: Colors.white70),
                  child: Image.network("https://i.postimg.cc/k5DpLQKQ/baato-Logo.png"),
                ),
              ),
            ),
            alignment: Alignment.bottomLeft,
          ),
          Align(
            child: Container(
              decoration: BoxDecoration(color: Colors.white70),
              padding: EdgeInsets.only(bottom: 2.0,right: 2.0),
              child: InkWell(
                child: RichText(
                  text: TextSpan(
                    text: "© ",
                    style: TextStyle(color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                        text: "OpenStreetMap contributors",
                        style: TextStyle(
                            color: Colors.purple, fontWeight: FontWeight.normal, decoration: TextDecoration.underline,),
                      ),
                    ],
                  ),
                ),
                onTap: () async {
                  if (await canLaunch("https://www.openstreetmap.org/copyright") != null) {
                    await launch("https://www.openstreetmap.org/copyright");
                  }
                },
              ),
            ),
            alignment: Alignment.bottomRight,
          )
        ]));
  }
}
