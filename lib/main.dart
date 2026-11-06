import 'package:flutter/material.dart';
import 'package:soporte_app/screens/incidencias_screen.dart';
import 'package:soporte_app/screens/inicio_screen.dart';
import 'package:soporte_app/screens/registro_incidencia_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SoporteApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 33, 150, 243),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const InicioScreen(),
        '/registro': (context) => const RegistroIncidenciaScreen(),
        '/incidencias': (context) => const IncidenciasScreen(),
      },
    );
  }
}
