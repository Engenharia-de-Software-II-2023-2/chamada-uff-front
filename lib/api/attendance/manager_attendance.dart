import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import '../../modelos/geolocation.dart';


class ManagerAttendance {

  static Future<bool> createAttendance(int id) async {
    final storage = FlutterSecureStorage();
    final url = Uri.parse(
        'https://engsoft2grupo3api.azurewebsites.net/attendance/createAttendance/$id');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final String attendanceId = data['attendanceId'];
      await storage.write(key: 'attendanceId', value: attendanceId);
      // como vamos definir o momento de criar uma nova chamada ou ativar e desativar uma já aberta?
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> controlAttendance() async {
    final storage = FlutterSecureStorage();
    final url = Uri.parse(
        'https://engsoft2grupo3api.azurewebsites.net/attendance/controlAttendance');
    final attendanceId = await storage.read(key: 'attendanceId');
    final Geolocation geolocation = await Geolocation.getGeolocation();
    final jsonData = json.encode({
      "id": attendanceId,
      "latitude": geolocation.latitude,
      "longitude": geolocation.longitude,
    });

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonData,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> checkActiveCall(int id) async {
    final storage = FlutterSecureStorage();
    final url = Uri.parse(
        'http://localhost:8080/attendance/getActiveAttendances/$id');

    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final String attendanceId = data['attendanceId'];
      await storage.write(key: 'attendanceId', value: attendanceId);
      return true;
    } else {
      return false;
    }

  }

  static Future<bool> markAttendance() async {
    final storage = FlutterSecureStorage();

  }

}

