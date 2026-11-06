import 'package:flutter/material.dart';
import 'package:soporte_app/models/incidencia.dart';
import 'package:soporte_app/services/incidencia_service.dart';

class RegistroIncidenciaScreen extends StatefulWidget {
  final Incidencia? incidencia;

  const RegistroIncidenciaScreen({super.key, this.incidencia});

  @override
  State<RegistroIncidenciaScreen> createState() => _RegistroIncidenciaScreenState();
}

class _RegistroIncidenciaScreenState extends State<RegistroIncidenciaScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nombreController;
  late final TextEditingController _correoController;
  late final TextEditingController _numeroEquipoController;
  late final TextEditingController _descripcionController;

  String? _prioridadSeleccionada;
  String? _estadoSeleccionado;
  bool _guardando = false;

  final List<String> _opcionesPrioridad = ['Baja', 'Media', 'Alta'];
  final List<String> _opcionesEstado = ['Pendiente', 'En proceso', 'Resuelta'];

  @override
  void initState() {
    super.initState();
    final item = widget.incidencia;
    _nombreController = TextEditingController(text: item?.nombreUsuario ?? '');
    _correoController = TextEditingController(text: item?.correo ?? '');
    _numeroEquipoController = TextEditingController(
      text: item != null ? item.numeroEquipo.toString() : '',
    );
    _descripcionController = TextEditingController(text: item?.descripcion ?? '');

    _prioridadSeleccionada = item?.prioridad;
    _estadoSeleccionado = item?.estado ?? 'Pendiente';
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _correoController.dispose();
    _numeroEquipoController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  Future<void> _guardarIncidencia() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _guardando = true;
    });

    final nuevaIncidencia = Incidencia(
      id: widget.incidencia?.id,
      nombreUsuario: _nombreController.text.trim(),
      correo: _correoController.text.trim(),
      numeroEquipo: int.parse(_numeroEquipoController.text.trim()),
      descripcion: _descripcionController.text.trim(),
      prioridad: _prioridadSeleccionada!,
      estado: _estadoSeleccionado!,
    );

    try {
      if (widget.incidencia == null) {
        await IncidenciaService.createIncidencia(nuevaIncidencia);
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Incidencia registrada correctamente'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushReplacementNamed(context, '/incidencias');
      } else {
        final actualizada = await IncidenciaService.updateIncidencia(
          widget.incidencia!.id!,
          nuevaIncidencia,
        );
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Incidencia actualizada correctamente'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context, actualizada);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al procesar la incidencia: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _guardando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final esEdicion = widget.incidencia != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(esEdicion ? 'Editar Incidencia' : 'Registrar Incidencia'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del usuario',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El nombre de usuario es obligatorio';
                  }
                  if (value.trim().length < 3) {
                    return 'El nombre debe tener un mínimo de 3 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _correoController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Correo electrónico',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El correo electrónico es obligatorio';
                  }
                  final trimmed = value.trim();
                  if (!trimmed.contains('@') || !trimmed.contains('.')) {
                    return 'El correo debe contener @ y punto (.)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _numeroEquipoController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Número de equipo',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El número de equipo es obligatorio';
                  }
                  final parsed = int.tryParse(value.trim());
                  if (parsed == null) {
                    return 'Debe ingresar un valor numérico';
                  }
                  if (parsed <= 0) {
                    return 'El número de equipo debe ser mayor que cero';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _descripcionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Descripción del problema',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'La descripción es obligatoria';
                  }
                  if (value.trim().length < 10) {
                    return 'La descripción debe tener un mínimo de 10 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                initialValue: _prioridadSeleccionada,
                decoration: const InputDecoration(
                  labelText: 'Prioridad',
                  border: OutlineInputBorder(),
                ),
                items: _opcionesPrioridad.map((p) {
                  return DropdownMenuItem<String>(
                    value: p,
                    child: Text(p),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Debe seleccionar una prioridad (Baja, Media o Alta)';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _prioridadSeleccionada = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                initialValue: _estadoSeleccionado,
                decoration: const InputDecoration(
                  labelText: 'Estado',
                  border: OutlineInputBorder(),
                ),
                items: _opcionesEstado.map((e) {
                  return DropdownMenuItem<String>(
                    value: e,
                    child: Text(e),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Debe seleccionar un estado (Pendiente, En proceso o Resuelta)';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _estadoSeleccionado = value;
                  });
                },
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _guardando ? null : _guardarIncidencia,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  _guardando
                      ? 'Guardando...'
                      : (esEdicion ? 'Guardar cambios' : 'Registrar incidencia'),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
