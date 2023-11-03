class Classroom {
  final int id;
  final String name;
  final String professor;
  final String classCode;
  final String semester;
  final String classTime;
  bool isSwitchOn;


  Classroom({
    required this.id,
    required this.name,
    required this.professor,
    required this.classCode,
    required this.semester,
    required this.classTime,
    this.isSwitchOn = false,
  });
}
