import 'package:chamada_inteligente/modelos/classroom.dart';

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