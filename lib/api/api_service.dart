import 'package:chamada_inteligente/modelos/classroom.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
//todo: realizar testes
class AuthService {
  final storage = FlutterSecureStorage();

  Future<bool> doLogin(String login, String senha) async {
    final url =
        Uri.parse('https://engsoft2grupo3api.azurewebsites.net/auth/login');
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
      final int id = data['id'];
      final String role = data['role'];

      await storage.write(key: 'token', value: token);
      await storage.write(key: 'id', value: id.toString());
      await storage.write(key: 'role', value: role);
      return true;
    } else {
      return false;
    }
  }

  Future<List<Classroom>> studentClassList() async {
    //sempre pega o aluno de id 1 idependente de qual fizer login
    final token = await storage.read(key: 'token');
    final id = await storage.read(key: 'id');
    final jsonData =
        json.encode({"studentId": id, "year": "2023", "semester": 1});
    final url = Uri.parse(
        'https://engsoft2grupo3api.azurewebsites.net/enrollment/getStudentEnrollments'); // Substitua pela URL correta
    final response = await http.post(url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
        body: jsonData);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> classesData = data['enrollments'];
      if (classesData.isNotEmpty) {
        List<Classroom> classes = [];
        for (var element in classesData) {
          Classroom current_class = Classroom(
              id: element['id'],
              name: element['subjectName'],
              professor: element['professorName'],
              classCode: element['className'],
              semester: element['semester'].toString(),
              classTime: element['schedule'],
              activeClass: element['active']);
          classes.add(current_class);
        }
        return classes;
      } else {
        throw Exception('Não há inscrição de turmas nesse período');
      }
    }
    throw Exception('Falha ao obter a lista de classes');
  }

  Future<List<Classroom>> professorClassList() async {
    //logar com professor, admin123
    final token = await storage.read(key: 'token');
    final id = await storage.read(key: 'id');
    final jsonData =
        json.encode({"professorId": id, "year": "2023", "semester": 1});
    final url = Uri.parse(
        'https://engsoft2grupo3api.azurewebsites.net/class/professsorClasses');
    final response = await http.post(url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
        body: jsonData);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> classesData = data['professorClasses'];
      if (classesData.isNotEmpty) {
        List<Classroom> classes = [];
        for (var element in classesData) {
          Classroom current_class = Classroom(
              id: element['classId'],
              name: element['subjectName'],
              professor: "Professor 1",
              classCode: element['className'],
              semester: element['semester'].toString(),
              classTime: element['schedule'],
              activeClass: element['active']);
          classes.add(current_class);
        }
        return classes;
      } else {
        throw Exception('Não há inscrição de turmas nesse período');
      }
    }
    throw Exception('Falha ao obter a lista de classes');
  }

  Future<List<Classroom>> getClassList() async {
    final List<Classroom> classes;
    final role = await storage.read(key: 'role');
    if (role == "STUDENT") {
      classes = await studentClassList();
    } else {
      classes = await professorClassList();
    }
    return classes;
  }
}
