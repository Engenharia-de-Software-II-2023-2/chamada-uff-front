// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_declarations, non_constant_identifier_names, use_build_context_synchronously, must_be_immutable

import 'package:chamada_inteligente/modelos/historico_informacao_turma.dart';
import 'package:chamada_inteligente/telas/informacao_chamada_professor.dart';
import 'package:chamada_inteligente/widgets/padrao/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'informacao_chamada_aluno.dart';

// List<HistoricoInformacaoTurma> instancia_historico() {
//   List<HistoricoInformacaoTurma> historicos = [];
//   for (int i = 0; i < 5; i++) {
//     // HistoricoInformacaoTurma historico =
//     // HistoricoInformacaoTurma("2023/11/0$i", "08:00", "09:30", i);
//     // historicos.add(historico);
//   }
//   return historicos;
// }

Future<List> historico_professor(classId) async {
  final token = await FlutterSecureStorage().read(key: 'token');
  var url = Uri.parse(
      'https://engsoft2grupo3api.azurewebsites.net/attendance/findAttendancesByClassId/$classId');
  var headers = {'Authorization': 'Bearer $token'};
  var response = await http.get(url, headers: headers);
  List<HistoricoInformacaoTurma> historicos = [];
  String dataFormatada = 'Não disponível';
  String horaString = 'Não disponível';
  if (response.statusCode == 200) {
    List data = json.decode(response.body);
    for (var element in data) {
      if (element['start'] != null) {
        List<String> partes = element['start'].split('T');
        String dataString = partes[0];
        horaString = partes[1];
        DateTime data = DateTime.parse(dataString);
        dataFormatada = "${data.day}/${data.month}/${data.year}";
      } else {
        dataFormatada = 'Sem data especificada';
        horaString = 'Sem hora especificada';
      }
      HistoricoInformacaoTurma current_class = HistoricoInformacaoTurma(
          class_id: element['classId'],
          chamada_id: element['id'],
          hora_comeco: horaString,
          duracao: element['duration'] ?? 0,
          status: element['status'],
          data: dataFormatada);
      historicos.add(current_class);
    }
  } 
  return historicos;
}

class HistoricoChamada extends StatefulWidget {
  int class_id;
  HistoricoChamada({Key? key, required this.class_id}) : super(key: key);

  @override
  State<HistoricoChamada> createState() => _HistoricoChamadaState();
}

class _HistoricoChamadaState extends State<HistoricoChamada> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE1F4FE),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: DefaultAppBar(titleAppBar: "Histórico"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "Chamadas",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
              ),
            ),
            FutureBuilder(
              future: historico_professor(1),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  List hists = snapshot.data as List;
                  return Container(
                    height: MediaQuery.of(context).size.height -
                        200, // ou defina uma altura máxima específica
                    child: ListView.builder(
                      itemCount: hists.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(
                            top: 7.0,
                            left: 20,
                            right: 20,
                            bottom: 7.0,
                          ),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                            ),
                            child: ListTile(
                              title: Text('${hists[index].data}'),
                              trailing: Text(hists[index].hora_comeco),
                              onTap: () async {
                                var proxima_tela;
                                final role = await FlutterSecureStorage().read(key: 'role');
                                if (role == "STUDENT"){
                                  proxima_tela = InformacaoChamadaAluno(historico_turma: hists[index]);
                                }else{
                                  proxima_tela = InformacaoChamadaProfessor(historico_turma: hists[index]);
                                }
                                 
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => proxima_tela,
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
                return Container(); // Retorna um widget vazio por padrão
              },
            ),
          ],
        ),
      ),
    );
  }
}
