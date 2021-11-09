import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/widgets.dart' show ChangeNotifier;
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:movil/app/helpers/image_to_bytes.dart';
import 'package:movil/app/ui/utils/map_style.dart';

class HomeController extends ChangeNotifier{
final Map <MarkerId, Marker> _markers ={};

Set<Marker> get markers => _markers.values.toSet();
final _markersController = StreamController<String>.broadcast();
Stream <String> get onMarkerTap => _markersController.stream;


final initialCameraPosition = const CameraPosition(
  target: LatLng(32.4247606,-114.7438655),
  zoom: 15,
  );
 final  _bolsaIcon = Completer<BitmapDescriptor>();


  HomeController(){

    assetToBytes('assets/bolsa-de-dinero.png', width:130 ).then((value) {
      final bitmap = BitmapDescriptor.fromBytes(value);
      _bolsaIcon.complete(bitmap);
    },);
  }


  void onMapCreated(GoogleMapController controller){
    controller.setMapStyle(mapStyle);
  }

  void onTap(LatLng position) async{
    final id = _markers.length.toString();
    final markerId = MarkerId(id);

    final icon = await _bolsaIcon.future;

    final marker = Marker(
      markerId: markerId,
      position: position,
      draggable: true,
      // anchor: const Offset(0.5, 1),
      icon: icon,
      onTap: (){
        _markersController.sink.add(id);
      },
      onDragEnd: (newPosition){
        print("new position $newPosition");
      }
    );

    _markers[markerId] = marker;
    notifyListeners();
  }

  @override
  void dispose() {
    _markersController.close();
    super.dispose();
  }

}