import 'package:flutter/material.dart';
import 'package:soporte_app/models/incidencia.dart';
import 'package:soporte_app/screens/detalle_incidencias_screen.dart';
import 'package:soporte_app/services/incidencia_service.dart';

class IncidenciasScreen extends StatefulWidget {
  const IncidenciasScreen({super.key});

  @override
  State<IncidenciasScreen> createState() => _IncidenciasScreenState();
}

class _IncidenciasScreenState extends State<IncidenciasScreen> {
  late Future<List<Incidencia>> _incidenciasFuture;

  @override
  void initState() {
    super.initState();
    _cargarIncidencias();
  }

  void _cargarIncidencias() {
    setState(() {
      _incidenciasFuture = IncidenciaService.getIncidencias();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Incidencias Registradas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Recargar incidencias',
            onPressed: _cargarIncidencias,
          ),
        ],
      ),
      body: FutureBuilder<List<Incidencia>>(
        future: _incidenciasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Error al conectar con la API:\n${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _cargarIncidencias,
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            );
          }

          final incidencias = snapshot.data ?? [];

          if (incidencias.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'No hay incidencias registradas',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      await Navigator.pushNamed(context, '/registro');
                      _cargarIncidencias();
                    },
                    child: const Text('Registrar una incidencia'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              _cargarIncidencias();
            },
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              itemCount: incidencias.length,
              itemBuilder: (context, index) {
                final incidencia = incidencias[index];

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 6.0,
                    ),
                    title: Text(
                      incidencia.nombreUsuario,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Equipo: #${incidencia.numeroEquipo}'),
                          const SizedBox(height: 2),
                          Text(
                            'Prioridad: ${incidencia.prioridad}  |  Estado: ${incidencia.estado}',
                            style: const TextStyle(color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                    onTap: () async {
                      final cambioRealizado = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetalleIncidenciaScreen(
                            incidencia: incidencia,
                          ),
                        ),
                      );

                      if (cambioRealizado == true) {
                        _cargarIncidencias();
                      }
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Registrar nueva incidencia',
        onPressed: () async {
          await Navigator.pushNamed(context, '/registro');
          _cargarIncidencias();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}