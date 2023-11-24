import 'package:chamada_inteligente/modelos/classroom.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';



final storage = FlutterSecureStorage();
Future<List<Classroom>> studentClassList() async {
  final token = await storage.read(key: 'token');
  final id = await storage.read(key: 'id');
  print(id.toString());
  final jsonData = json.encode({
    "studentId": id,
    "year": "2023",
    "semester": 1
  });
  final url = Uri.parse(
      'https://engsoft2grupo3api.azurewebsites.net/enrollment/getStudentEnrollments');
  final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: jsonData
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    final List<dynamic> classesData = data['enrollments'];
    if (classesData.isNotEmpty) {
      final List<Classroom> classes = classesData.map((turma) {
        return Classroom(
          id: turma['id'] as int,
          name: turma['subjectName'],
          professor: turma['professorName'],
          classCode: turma['className'],
          semester: turma['semester'],
          classTime: turma['schedule'],
        );
      }).toList();
      return classes;
    } else {
      throw Exception('Não há inscrição de turmas nesse período');
    }
  }
  throw Exception('Falha ao obter a lista de classes');
}

Future <List<Classroom>> professorClassList() async {
  final token = await storage.read(key: 'token');
  final id = await storage.read(key: 'id') ?? "0";
  final jsonData = json.encode({
    "professorId": int.parse(id),
    "year": "2023",
    "semester": 1
  });
  final url = Uri.parse(
      'https://engsoft2grupo3api.azurewebsites.net/class/professsorClasses'); // Substitua pela URL correta
  final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: jsonData
  );
  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    final List<dynamic> classesData = data['professorClasses'];
    if (classesData.isNotEmpty) {
      final List<Classroom> classes = classesData.map((turma) {
        return Classroom(
          id: turma['classId'] as int,
          name: turma['subjectName'],
          professor: 'não tem nome',
          classCode: turma['className'],
          semester: turma['semester'],
          classTime: turma['schedule'],
        );
      }).toList();

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
  if(role == "STUDENT") {
    classes = await studentClassList();
  } else{
    classes = await professorClassList();

  }
  return classes;
}