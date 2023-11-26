class Attendance {
  int id;
  int classId;
  String weekDay;
  String start;
  String end;
  double professorLatitude; // Latitude do professor
  double professorLongitude; // Longitude do professor

  Attendance({
    this.id = 0,
    this.classId = 0,
    this.weekDay = '',
    this.start = '',
    this.end = '',
    required this.professorLatitude, // Adicionando latitude do professor como parâmetro opcional
    required this.professorLongitude, // Adicionando longitude do professor como parâmetro opcional
  });

  // Construtor nomeado para criar uma instância com a localização do professor
  Attendance.withProfessorLocation({
    required this.id,
    required this.classId,
    required this.weekDay,
    required this.start,
    required this.end,
    required this.professorLatitude,
    required this.professorLongitude,
  });
}

