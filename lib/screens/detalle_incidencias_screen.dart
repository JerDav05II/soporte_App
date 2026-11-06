import 'package:flutter/material.dart';
import 'package:soporte_app/models/incidencia.dart';
import 'package:soporte_app/screens/registro_incidencia_screen.dart';
import 'package:soporte_app/services/incidencia_service.dart';

class DetalleIncidenciaScreen extends StatefulWidget {
  final Incidencia incidencia;

  const DetalleIncidenciaScreen({super.key, required this.incidencia});

  @override
  State<DetalleIncidenciaScreen> createState() => _DetalleIncidenciaScreenState();
}

class _DetalleIncidenciaScreenState extends State<DetalleIncidenciaScreen> {
  late Incidencia _incidenciaActual;
  bool _huboCambios = false;
  bool _eliminando = false;

  @override
  void initState() {
    super.initState();
    _incidenciaActual = widget.incidencia;
  }

  IconData _getIconoPrioridad(String prioridad) {
    switch (prioridad.toLowerCase()) {
      case 'alta':
        return Icons.error;
      case 'media':
        return Icons.warning;
      case 'baja':
      default:
        return Icons.info;
    }
  }

  String _formatearFecha(DateTime? fecha) {
    if (fecha == null) return 'No disponible';
    final y = fecha.year;
    final m = fecha.month.toString().padLeft(2, '0');
    final d = fecha.day.toString().padLeft(2, '0');
    final h = fecha.hour.toString().padLeft(2, '0');
    final min = fecha.minute.toString().padLeft(2, '0');
    return '$d/$m/$y $h:$min';
  }

  Future<void> _abrirEdicion() async {
    final incidenciaActualizada = await Navigator.push<Incidencia>(
      context,
      MaterialPageRoute(
        builder: (context) => RegistroIncidenciaScreen(
          incidencia: _incidenciaActual,
        ),
      ),
    );

    if (incidenciaActualizada != null) {
      setState(() {
        _incidenciaActual = incidenciaActualizada;
        _huboCambios = true;
      });
    }
  }

  Future<void> _confirmarYEliminar() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: const Text(
            '¿Está seguro de que desea eliminar esta incidencia? Esta acción no se puede deshacer.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirmar != true) {
      return;
    }

    setState(() {
      _eliminando = true;
    });

    try {
      if (_incidenciaActual.id != null) {
        await IncidenciaService.deleteIncidencia(_incidenciaActual.id!);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Incidencia eliminada correctamente'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al eliminar la incidencia: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _eliminando = false;
        });
      }
    }
  }

  Widget _buildCampo(String etiqueta, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            etiqueta,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            valor,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final prioridadIcon = _getIconoPrioridad(_incidenciaActual.prioridad);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.pop(context, _huboCambios);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Detalle de Incidencia'),
        ),
        body: _eliminando
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(prioridadIcon, size: 24),
                                const SizedBox(width: 8),
                                Text(
                                  'Prioridad: ${_incidenciaActual.prioridad}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  'Estado: ${_incidenciaActual.estado}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 24),

                            _buildCampo('Nombre del usuario', _incidenciaActual.nombreUsuario),
                            _buildCampo('Correo electrónico', _incidenciaActual.correo),
                            _buildCampo('Número de equipo', '#${_incidenciaActual.numeroEquipo}'),
                            _buildCampo('Descripción del problema', _incidenciaActual.descripcion),
                            _buildCampo('Fecha de registro', _formatearFecha(_incidenciaActual.fechaRegistro)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _abrirEdicion,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text('Editar'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _confirmarYEliminar,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text('Eliminar'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
