import 'package:chamada_inteligente/modelos/classroom.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../helpers/salas_de_aula_dummy.dart';
import 'package:flutter/material.dart';

class AuthService {
  final storage = FlutterSecureStorage();

  Future<bool> doLogin(String login, String senha) async {
    final url = Uri.parse('https://engsoft2grupo3api.azurewebsites.net/auth/login');

    final response = await http.post(
      url,
      body: {
        "username": login,
        "password": senha,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final String token = data['token'];
      print(token);
      await storage.write(key: 'token', value: token);

      return true;
    } else {
      return false;
    }
  }

  Future<List<Classroom>> getClassList(int userId) async {
    final token = await storage.read(key: 'token');
    final url = Uri.parse('https://engsoft2grupo3api.azurewebsites.net/enrollment/getStudentEnrollments'); // Substitua pela URL correta
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
      body: {
        "studentId": userId,
      }
    );

    if (response.statusCode == 200) {
      final List<String> data = json.decode(response.body);
      final List<Classroom> classes = classrooms;

      /*for (final turma in data) {
        final classroom = Classroom(
          id: turma['id'],
          name: turma['className'],
          professor: turma['studentName'],
          className: turma['className'],
          createdAt: DateTime.parse(turma['createdAt']),
        );

        classes.add(classroom);
      }*/

      return classes;
    } else {
      throw Exception('Falha ao obter a lista de classes');
    }
  }
}


