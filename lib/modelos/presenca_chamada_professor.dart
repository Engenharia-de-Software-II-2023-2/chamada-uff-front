import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PresencaChamadaProfessor {
  final int chamada_id;
  final int aluno_id;
  final int id;
  final String inicio_chamada;
  final String final_chamada;
  final bool presenca;
  late String? nome_aluno;

  PresencaChamadaProfessor({
    this.nome_aluno,
    required this.chamada_id,
    required this.aluno_id,
    required this.id,
    required this.inicio_chamada,
    required this.final_chamada,
    required this.presenca,
  });
//todo: realizar testes
  Future<String> get_nomealuno() async {
    var aluno_id = this.aluno_id;
    final token = await FlutterSecureStorage().read(key: 'token');
    var url = Uri.parse(
        'https://engsoft2grupo3api.azurewebsites.net/users/id/$aluno_id');
    var headers = {'Authorization': 'Bearer $token'};
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      String nome = data['name'] as String;
      return nome;
    }
    return 'Não encontrado';
  }
}
