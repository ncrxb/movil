import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

final _initialCameraPosition = CameraPosition(
  target: LatLng(32.4247606,-114.7438655),
  zoom: 15,
  );



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GoogleMap(initialCameraPosition: _initialCameraPosition),
    );
  }
}