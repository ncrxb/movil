import 'dart:async';
import 'package:flutter/widgets.dart' show ChangeNotifier;
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:movil/app/helpers/image_to_bytes.dart';
import 'package:movil/app/ui/utils/map_style.dart';
import 'package:geolocator/geolocator.dart';

class HomeController extends ChangeNotifier{
final Map <MarkerId, Marker> _markers ={};

Set<Marker> get markers => _markers.values.toSet();
final _markersController = StreamController<String>.broadcast();
Stream <String> get onMarkerTap => _markersController.stream;

Position? _initialPosition;
Position? get initialPosition => _initialPosition;

 final  _bolsaIcon = Completer<BitmapDescriptor>();

bool _loading = true;
bool get loading => _loading;

late bool _gpsEnabled;
bool get gpsEnabled => _gpsEnabled;

StreamSubscription?_gpsSubscription;


  HomeController(){
    _init(); 
  }

  Future <void> _init() async {
   assetToBytes('assets/bolsa-de-dinero.png', width:130 ).then((value) {
      final bitmap = BitmapDescriptor.fromBytes(value);
      _bolsaIcon.complete(bitmap);
    },);
   _gpsEnabled = await Geolocator.isLocationServiceEnabled();
    _loading = false;
   _gpsSubscription = Geolocator.getServiceStatusStream().listen(
      (status) async{
        _gpsEnabled = status == ServiceStatus.enabled;
        await _getInitialPosition();
        notifyListeners();
      },
      );
      await _getInitialPosition();
     
    notifyListeners();
  }

Future<void>_getInitialPosition() async {
  if(_gpsEnabled){
       _initialPosition = await  Geolocator.getCurrentPosition();
      }
}

  void onMapCreated(GoogleMapController controller){
    controller.setMapStyle(mapStyle);
  }

  Future <void> turnOnGPS() =>   Geolocator.openLocationSettings();
  

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
    _gpsSubscription?.cancel();
    _markersController.close();
    super.dispose();
  }

}