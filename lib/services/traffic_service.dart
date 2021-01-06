
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:mapa_app/helpers/debouncer.dart';
import 'package:mapa_app/models/search_response.dart';
import 'package:mapa_app/models/traffic_response.dart';

class TrafficService {
  //Singleton
  TrafficService._privateConstructor();
  static final TrafficService _instance = TrafficService._privateConstructor();
  factory TrafficService(){
    return _instance;
  }

  final _dio = new Dio();
  final debouncer = Debouncer<String>(duration: Duration(milliseconds: 400 ));

  final StreamController<SearchResponse> _sugerenciasStreamController = StreamController<SearchResponse>.broadcast();
  Stream<SearchResponse> get sugerenciaStream => this._sugerenciasStreamController.stream;

  final _baseURLDir = 'https://api.mapbox.com/directions/v5';
  final _baseURLGeo = 'https://api.mapbox.com/geocoding/v5';
  final _apiKey = 'pk.eyJ1IjoidG9ueW92YWxsZSIsImEiOiJja2diMmhiMG4wMG0xMnNtd290dWc3bHdvIn0.inEIKQpnhaInqKu-mV9FBQ';

  Future<DrivingResponse> getCoordsInicioYDestino( LatLng inicio, LatLng destino ) async {

    final coordString = '${ inicio.longitude },${ inicio.latitude };${ destino.longitude },${ destino.latitude }';
    final url = '${ this._baseURLDir }/mapbox/driving/$coordString';

    final resp = await this._dio.get( url, queryParameters: {
      'alternatives': 'true',
      'geometries': 'polyline6',
      'steps': 'false',
      'access_token': this._apiKey,
      'language': 'es',
    });

    final data = DrivingResponse.fromJson(resp.data);

    return data;

  }

  Future<SearchResponse> getResultadosPorQuery( String busqueda, LatLng proximidad ) async {

    print('Buscando!!!!!');

    final url = '${ this._baseURLGeo }/mapbox.places/$busqueda.json';

    try {
        final resp = await this._dio.get(url, queryParameters: {
          'access_token': this._apiKey,
          'autocomplete': 'true',
          'proximity'   : '${ proximidad.longitude },${ proximidad.latitude }',
          'language'    : 'es',
        });

        final searchResponse = searchResponseFromJson( resp.data );

        return searchResponse;

    } catch (e) {
      return SearchResponse( features: [] );
    }

  
  }

  void getSugerenciasPorQuery( String busqueda, LatLng proximidad ) {

    debouncer.value = '';
    debouncer.onValue = ( value ) async {
      final resultados = await this.getResultadosPorQuery(value, proximidad);
      this._sugerenciasStreamController.add(resultados);
    };

    final timer = Timer.periodic(Duration(milliseconds: 200), (_) {
      debouncer.value = busqueda;
    });

    Future.delayed(Duration(milliseconds: 201)).then((_) => timer.cancel()); 

  }


}