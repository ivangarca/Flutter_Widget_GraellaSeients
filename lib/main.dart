import 'package:flutter/material.dart'; //colores
import 'package:provider/provider.dart'; //viewmodel y vista se comuniquen

import 'model/graella_seients_state.dart';
import 'viewmodel/main_viewmodel.dart';
import 'view/main_screen.dart';

void main() {
  runApp(const MyApp()); //Coge este widget (MyApp) y ponlo a pantalla completa para arrancar la aplicación
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  /// Funció de factoria per crear el ViewModel
  MainViewModel createViewModel(BuildContext context) {
    const estatInicial = GraellaSeientsState(
      maxSeleccionables: 5,
    );
    // Creem i retornem el ViewModel
    return MainViewModel(estatInicial);
  }


  ///¿Qué hace esto? Ejecuta tu función createViewModel para encender el cerebro, y crea un "campo de energía" alrededor
  ///de MainScreen.
  // Gracias a este envoltorio, cuando dentro de tu main_screen.dart escribiste context.watch<MainViewModel>(),
  // la pantalla pudo conectarse al cerebro. Si no hubieras puesto este ChangeNotifierProvider aquí en el main.dart,
  // la app habría explotado al intentar escuchar un cerebro que no está "enchufado" a la red.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, //quita un texto de DEBUG
      title: 'Graella de Seients',
      home: ChangeNotifierProvider( //Le dice a la app cuál es la primera pantalla que debe mostrar.
        create: createViewModel,
        child: const MainScreen(),
      ),
    );
  }
}