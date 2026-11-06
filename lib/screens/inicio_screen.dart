import 'package:flutter/material.dart';

class InicioScreen extends StatelessWidget {
  const InicioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.support_agent),
            SizedBox(width: 8),
            Text('SoporteApp'),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              Center(
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 180),
                  child: Image.asset(
                    'assets/images/soporte.jpeg',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'lib/assets/images/soporte.jpeg',
                        fit: BoxFit.contain,
                        errorBuilder: (ctx, err, st) => const SizedBox(height: 100),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'Gestión de Incidencias Técnicas',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Registra y administra los problemas técnicos detectados en los equipos informáticos para facilitar su seguimiento y atención.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 36),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/registro');
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Registrar incidencia'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/incidencias');
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Ver incidencias'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
