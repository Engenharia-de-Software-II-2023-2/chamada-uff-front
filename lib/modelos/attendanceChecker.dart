import 'package:geolocator/geolocator.dart';

class AttendanceChecker {
  static Future<bool> checkAttendance(
      double professorLatitude, double professorLogitude, double studentLatitude, double studentLogitude) async {
      double radius = 15.0;
      double distance = await Geolocator.distanceBetween(
        professorLatitude,
        professorLogitude,
        studentLatitude,
        studentLogitude,
      );

    return distance <= radius;
  }
}

// Exemplo de uso:
/*void main() async {
  Position professorLocation = Position(latitude: 123.456, longitude: 789.123);
  Position studentLocation = Position(latitude: 123.459, longitude: 789.125);
   // Raio de tolerância em metros

  bool isWithinRadius = await AttendanceChecker.checkAttendance(
    professorLocation,
    studentLocation,
    radius,
  );

  if (isWithinRadius) {
    print('O aluno está dentro do raio de tolerância.');
  } else {
    print('O aluno está fora do raio de tolerância.');
  }
}*/
