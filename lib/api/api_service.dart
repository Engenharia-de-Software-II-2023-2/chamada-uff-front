import 'package:chamada_inteligente/modelos/classroom.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../telas/autentificacao/tela_autentificacao.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class AuthService {
  final storage = FlutterSecureStorage();

  Future<bool> doLogin(String login, String senha) async {
    final url = Uri.parse('https://engsoft2grupo3api.azurewebsites.net/auth/login');
    final jsonData = json.encode({
      "username": login,
      "password": senha,
    });
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonData,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final String token = data['token'];
      final String id = data['id'];
      final String role = data['role'];
      await storage.write(key: 'token', value: token);
      await storage.write(key: 'id', value: id);
      await storage.write(key: 'role', value: role);
      return true;

    } else {
      return false;
    }
  }

  Future<List<Classroom>> getClassList(int userId) async {
    final token = await storage.read(key: 'token');
    final role = await storage.read(key: 'role');
    final id = await storage.read(key: 'id');
    final jsonData = json.encode({
      "studentId": userId,
    });
    final url = Uri.parse('https://engsoft2grupo3api.azurewebsites.net/enrollment/getStudentEnrollments'); // Substitua pela URL correta
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: jsonData
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      final List<Classroom> classes = data.map((turma) {
        return Classroom(
          id: turma['id'] as int,
          name: turma['className'],
          professor: turma['studentName'],
          classCode: 'ABC123',
          semester: '2023/1',
          classTime: 'Segunda-feira, 14:00-16:00',
          activeClass: false,
        );
      }).toList();

      return classes;
    } else {
      throw Exception('Falha ao obter a lista de classes');
    }
  }

  void performLogout(BuildContext context) async{
    await storage.delete(key: 'token');
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const TelaAutentificacao(),
      ),
    );
  }
}


