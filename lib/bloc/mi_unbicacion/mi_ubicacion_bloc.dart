import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart' as Geolocation;
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

part 'mi_ubicacion_event.dart';
part 'mi_ubicacion_state.dart';

class MiUbicacionBloc extends Bloc<MiUbicacionEvent, MiUbicacionState> {
  MiUbicacionBloc() : super(MiUbicacionState());

  //Golocator
  StreamSubscription<Geolocation.Position> _psitionSubscription;

  void iniciarSeguimiento(){    
    _psitionSubscription = Geolocation.getPositionStream(
      desiredAccuracy: Geolocation.LocationAccuracy.high,
      distanceFilter: 10
    ).listen((Geolocation.Position position) {
      final nuevaUbicacion = LatLng(position.latitude, position.longitude);
      add(OnUbicacionCambio(nuevaUbicacion));
    });
  }

  void cancelarSeguimiento() {
    _psitionSubscription?.cancel();
  }

  @override
  Stream<MiUbicacionState> mapEventToState(MiUbicacionEvent event) async* {
    if(event is OnUbicacionCambio){
      yield state.copyWith(
        existeUbicacion: true,
        ubicacion: event.ubicacion
      );
    }
  }
}
