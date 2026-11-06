import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:soporte_app/core/api_config.dart';
import 'package:soporte_app/models/incidencia.dart';

class IncidenciaService {
  static Future<List<Incidencia>> getIncidencias() async {
    final url = Uri.parse(ApiConfig.incidenciasUrl);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      return body.map((item) => Incidencia.fromJson(item)).toList();
    } else {
      throw Exception('Error al cargar incidencias: ${response.statusCode}');
    }
  }

  static Future<Incidencia> getIncidencia(int id) async {
    final url = Uri.parse('${ApiConfig.incidenciasUrl}$id');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final dynamic body = jsonDecode(utf8.decode(response.bodyBytes));
      return Incidencia.fromJson(body);
    } else {
      throw Exception('Error al obtener la incidencia');
    }
  }

  static Future<Incidencia> createIncidencia(Incidencia incidencia) async {
    final url = Uri.parse(ApiConfig.incidenciasUrl);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(incidencia.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final dynamic body = jsonDecode(utf8.decode(response.bodyBytes));
      return Incidencia.fromJson(body);
    } else {
      throw Exception('Error al guardar incidencia: ${response.body}');
    }
  }

  static Future<Incidencia> updateIncidencia(int id, Incidencia incidencia) async {
    final url = Uri.parse('${ApiConfig.incidenciasUrl}$id');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(incidencia.toJson()),
    );

    if (response.statusCode == 200) {
      final dynamic body = jsonDecode(utf8.decode(response.bodyBytes));
      return Incidencia.fromJson(body);
    } else {
      throw Exception('Error al actualizar la incidencia: ${response.body}');
    }
  }

  static Future<bool> deleteIncidencia(int id) async {
    final url = Uri.parse('${ApiConfig.incidenciasUrl}$id');
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Error al eliminar la incidencia: ${response.statusCode}');
    }
  }
}
