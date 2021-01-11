part of 'mapa_bloc.dart';

@immutable
class MapaState {
  final bool mapaListo;
  final bool seguirUbicacion;
  final bool dibujarRecorrido;
  final LatLng ubicacionCentral;

  //Polylines
  final Map<String, Polyline> polylines;
  final Map<String, Marker> markers;

  MapaState({
    this.mapaListo = false,
    this.seguirUbicacion = false,
    this.dibujarRecorrido = false,
    this.ubicacionCentral,
    Map<String, Polyline> polylines,
    Map<String, Marker> markers
  }): this.polylines = polylines ?? new Map(),
      this.markers = markers ?? new Map();

  MapaState copyWith({
    bool mapaListo,
    bool seguirUbicacion,
    bool dibujarRecorrido,
    LatLng ubicacionCentral,
    Map<String, Marker> markers,
    Map<String, Polyline> polylines
  }) => MapaState(
    markers : markers ?? this.markers,
    mapaListo: mapaListo ?? this.mapaListo,
    polylines: polylines ?? this.polylines,
    ubicacionCentral: ubicacionCentral ?? this.ubicacionCentral,
    seguirUbicacion: seguirUbicacion ?? this.seguirUbicacion,
    dibujarRecorrido: dibujarRecorrido ?? this.dibujarRecorrido,
  );
}