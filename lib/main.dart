import 'package:flutter/material.dart';
import 'screens/class_list.dart';
import 'screens/classroom_detail.dart';
import 'models/classroom.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final List<Classroom> classrooms = [
    Classroom(
      id: 1,
      name: 'Turma A',
      professor: 'Professor 1',
      classCode: 'ABC123',
      semester: '2023/1',
      classTime: 'Segunda-feira, 14:00-16:00',
      activeClass: true,
    ),
    Classroom(
      id: 2,
      name: 'Turma B',
      professor: 'Professor 2',
      classCode: 'DEF456',
      semester: '2023/1',
      classTime: 'Terça-feira, 10:00-12:00',
      activeClass: false,
    ),
    // Add more classrooms here
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chamadas em Tempo Real',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.blue[50],
      ),
      initialRoute: '/classList',
      routes: {
        '/classList': (ctx) => ClassListScreen(classrooms),
        //'/classroomDetail': (ctx) => ClassroomDetailScreen(classroom),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/classroomDetail') {
          final classroom = settings.arguments as Classroom;
          return MaterialPageRoute(
            builder: (ctx) => ClassroomDetailScreen(classroom),
          );
        }
        return null;
      },
    );
  }
}





