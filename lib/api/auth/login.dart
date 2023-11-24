
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';


class AuthService {
  final storage = FlutterSecureStorage();

  Future<bool> doLogin(String login, String senha) async {
    final url = Uri.parse(
        'https://engsoft2grupo3api.azurewebsites.net/auth/login');
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

}

