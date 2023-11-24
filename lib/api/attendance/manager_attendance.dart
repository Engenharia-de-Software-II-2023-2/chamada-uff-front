import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import '../../modelos/geolocation.dart';
import '../../modelos/attendanceChecker.dart';


class ManagerAttendance {

  static Future<bool> createAttendance(int id) async {
    print('abrindo chamada (função)');
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    final url = Uri.parse(
        'https://engsoft2grupo3api.azurewebsites.net/attendance/createAttendance');
    final jsonData = json.encode({
      "classId": id,
    });

    final response = await http.post(
      url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
      body: jsonData
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final int attendanceId = data['attendanceId'];
      await storage.write(key: 'attendanceId', value: attendanceId.toString());
      // como vamos definir o momento de criar uma nova chamada ou ativar e desativar uma já aberta?
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> controlAttendance() async {
    print('ativando chamada (função)');
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    final url = Uri.parse(
        'https://engsoft2grupo3api.azurewebsites.net/attendance/controlAttendance');

    // Lê o valor de attendanceId do armazenamento seguro
    final attendanceIdString = await storage.read(key: 'attendanceId');

    // Verifica se attendanceIdString não é nulo ou vazio antes de fazer a conversão
    if (attendanceIdString != null && attendanceIdString.isNotEmpty) {
      // Converte attendanceIdString para um inteiro
      final attendanceId = int.parse(attendanceIdString);

      final Geolocation geolocation = await Geolocation.getGeolocation();
      final jsonData = json.encode({
        "id": attendanceId,
        "latitude": geolocation.latitude,
        "longitude": geolocation.longitude,
      });

      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
        body: jsonData,
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } else {
      // Trate o caso em que attendanceIdString é nulo ou vazio
      print('attendanceId não é válido.');
      return false;
    }
  }


  static Future<bool> checkActiveCall(int id) async {
    print('checando status da chamada (função)');
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    final url = Uri.parse(
        'https://engsoft2grupo3api.azurewebsites.net/attendance/getActiveAttendances/$id');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> dataList = json.decode(response.body);

      // Verifica se a lista não está vazia
      if (dataList.isNotEmpty) {
        final Map<String, dynamic> data = dataList.first;
        print(data.toString());
        final int attendanceId = data['id'];
        final double latitude = data['latitude'];
        final double longitude = data['longitude'];
        await storage.write(key: 'attendanceId', value: attendanceId.toString());
        await storage.write(key: 'latitude', value: latitude.toString());
        await storage.write(key: 'longitude', value: longitude.toString());
        return true;
      } else {
        print('A lista de dados está vazia.');
        return false;
      }
    } else {
      return false;
    }
  }


  static Future<bool> markAttendance() async {
    final storage = FlutterSecureStorage();
    final latitudeString = await storage.read(key: 'latitude');
    final longitudeString = await storage.read(key: 'longitude');

    if (latitudeString != null && longitudeString != null) {
      final latitude = double.tryParse(latitudeString);
      final longitude = double.tryParse(longitudeString);

      if (latitude != null && longitude != null) {
        // Agora você pode usar latitude e longitude como valores double
        final Geolocation geolocation = await Geolocation.getGeolocation();
        bool inRadio = await AttendanceChecker.checkAttendance(
            latitude, longitude, geolocation.latitude, geolocation.longitude);
        if (inRadio) {
          final token = await storage.read(key: 'token');
          final attendanceIdString = await storage.read(key: 'attendanceId');
          final id = await storage.read(key: 'id');
          final url = Uri.parse(
              'https://engsoft2grupo3api.azurewebsites.net/response/createResponse');
          final jsonData = json.encode({
            "studentId": id,
            "attendanceId": attendanceIdString,
            "start": "2023-09-21T18:10:00",
            "end": "2023-09-21T20:10:00"
          });

          final response = await http.post(
              url,
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json'
              },
              body: jsonData
          );
          if (response.statusCode == 200) {
            return true;
          } else {
            return false;
          }
        } else {
          return false;
        }
      }
    }
    return false;
  }
}

