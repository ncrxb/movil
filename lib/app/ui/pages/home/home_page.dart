import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:movil/app/ui/pages/home/home_controller.dart';
import 'package:provider/provider.dart';


class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);





  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeController>(
      create: (_) {
        final controller = HomeController();
        controller.onMarkerTap.listen((String id) {
            print("Go to $id");
         });
        return controller;
      },
      child: Scaffold(
      appBar: AppBar(),
      body: Selector<HomeController, bool>(
        selector: (_,controller) => controller.loading,
        builder: (context, loading, loadingWidget){
        
        if(loading){
          return loadingWidget!;
        }
        
        return Consumer<HomeController>(
        builder:(_, controller, gpsMessageWidget) {

          if(!controller.gpsEnabled){
            return gpsMessageWidget!;
          }
        
        final initialPosition = LatLng(
          controller.initialPosition!.latitude, 
          controller.initialPosition!.longitude);

          return GoogleMap(
              markers: controller.markers,
              onMapCreated: controller.onMapCreated,
              initialCameraPosition: CameraPosition(target: initialPosition, zoom: 14),
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              compassEnabled: false,
              onTap: controller.onTap,
              );
           },

            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Para utilizar nuestra app necesita habilidar el GPS",
                  textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: (){
                     final controller = context.read<HomeController>();
                    controller.turnOnGPS();
                    }, 
                    child: const  Text("Turn on GPS"),
                    ),               
                ],
              ),
            ),

              );
        },
             child: const Center(
            child: CircularProgressIndicator(),
            )

        
      ),
      ),
    );
  }
}