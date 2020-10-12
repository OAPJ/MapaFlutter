import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mapa_app/pages/mapa_page.dart';
import 'package:mapa_app/pages/loading_page.dart';
import 'package:mapa_app/bloc/mapa/mapa_bloc.dart';
import 'package:mapa_app/pages/acceso_gps_page.dart';
import 'package:mapa_app/bloc/mi_unbicacion/mi_ubicacion_bloc.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => MiUbicacionBloc()),
        BlocProvider(create: (_) => MapaBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoadingPage(),
        routes: {
          'mapa': ( _ ) => MapaPage(),
          'loading': ( _ ) => LoadingPage(),
          'acceso_page': ( _ ) => AccesoGpsPage(),
        },
      ),
    );
  }
}