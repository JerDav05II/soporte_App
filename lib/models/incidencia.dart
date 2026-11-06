class Incidencia {
  final int? id;
  final String nombreUsuario;
  final String correo;
  final int numeroEquipo;
  final String descripcion;
  final String prioridad;
  final String estado;
  final DateTime? fechaRegistro;

  Incidencia({
    this.id,
    required this.nombreUsuario,
    required this.correo,
    required this.numeroEquipo,
    required this.descripcion,
    required this.prioridad,
    required this.estado,
    this.fechaRegistro,
  });

  factory Incidencia.fromJson(Map<String, dynamic> json) {
    return Incidencia(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? ''),
      nombreUsuario: json['nombre_usuario']?.toString() ?? '',
      correo: json['correo']?.toString() ?? '',
      numeroEquipo: json['numero_equipo'] is int
          ? json['numero_equipo']
          : int.tryParse(json['numero_equipo']?.toString() ?? '0') ?? 0,
      descripcion: json['descripcion']?.toString() ?? '',
      prioridad: json['prioridad']?.toString() ?? 'Baja',
      estado: json['estado']?.toString() ?? 'Pendiente',
      fechaRegistro: json['fecha_registro'] != null
          ? DateTime.tryParse(json['fecha_registro'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'nombre_usuario': nombreUsuario,
      'correo': correo,
      'numero_equipo': numeroEquipo,
      'descripcion': descripcion,
      'prioridad': prioridad,
      'estado': estado,
    };
    if (id != null) {
      data['id'] = id;
    }
    return data;
  }
}