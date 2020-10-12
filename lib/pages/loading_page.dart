import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as Geolocation;
import 'package:permission_handler/permission_handler.dart';

import 'package:mapa_app/helpers/helpers.dart';
import 'package:mapa_app/pages/mapa_page.dart';
import 'package:mapa_app/pages/acceso_gps_page.dart';

class LoadingPage extends StatefulWidget {

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> with WidgetsBindingObserver{
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if(state == AppLifecycleState.resumed){
      if(await Geolocation.isLocationServiceEnabled())
        Navigator.pushReplacement(context, navegarMapaFadein(context, MapaPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: this.checkGpsLocation(context),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(snapshot.hasData){
            return Center(child: Text(snapshot.data));
          }
          else{
            return Center(child: CircularProgressIndicator(strokeWidth: 2,));
          }
        },
      ),
    );
  }

  Future checkGpsLocation(BuildContext context) async{
    // PermisoGPS
    // GPS está activo
    final permisoGPS = await Permission.location.isGranted;
    final gpsActivo = await Geolocation.isLocationServiceEnabled();

    if(permisoGPS && gpsActivo){
      Navigator.pushReplacement(context, navegarMapaFadein(context, MapaPage()));
      return '';
    }
    else if(!permisoGPS){
      Navigator.pushReplacement(context, navegarMapaFadein(context, AccesoGpsPage()));
      return 'Es necesario el permiso del GPS';
    }
    else{

      return 'Active el GPS';
    }

//    await Future.delayed(Duration(milliseconds: 100));
//    Navigator.pushReplacement(context, navegarMapaFadein(context, MapaPage()));
    Navigator.pushReplacement(context, navegarMapaFadein(context, AccesoGpsPage()));
  }
}