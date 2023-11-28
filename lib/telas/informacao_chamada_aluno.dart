// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, non_constant_identifier_names, prefer_typing_uninitialized_variables, prefer_const_declarations

import 'dart:convert';

import 'package:chamada_inteligente/modelos/historico_informacao_turma.dart';
import 'package:chamada_inteligente/modelos/presenca_aluno.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../widgets/padrao/app_bar.dart';
import 'package:http/http.dart' as http;

Future<List> presenca_aluno(chamada_id, class_id) async {
  final token = await FlutterSecureStorage().read(key: 'token');
  // final user_id = await FlutterSecureStorage().read(key: 'id');
  List presencas = [];
  final class_id = 4;
  final jsonData = json.encode({"studentId": 1, "classId": 1});
  final url = Uri.parse(
      'https://engsoft2grupo3api.azurewebsites.net/enrollment/checkStudentAttendanceRecord');
  final response = await http.post(url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: jsonData);
  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    List classesData = data['attendanceRecordList'];
    for (var chamadada_atual in classesData) {
      if (chamadada_atual['attendanceId'] == chamada_id) {
        PresencaAluno presenca = PresencaAluno(
            chamada_id: chamadada_atual['attendanceId'],
            aluno_id: chamadada_atual['studentId'],
            class_id: chamadada_atual['classId'],
            inicio_chamada: chamadada_atual['start'] ?? 'Sem hora especificada' ,
            presenca:
                chamadada_atual['wasPresent'] == true ? 'Presente' : 'Ausente');
        presencas.add(presenca);
        return presencas;
      }
    }
  }
  PresencaAluno presenca = PresencaAluno(
      chamada_id: 0,
      aluno_id: 0,
      class_id: 0,
      inicio_chamada: 'Sem hora especificada',
      presenca: 'Ausente');
  presencas.add(presenca);
  return presencas;
}

class InformacaoChamadaAluno extends StatefulWidget {
  final historico_turma;
  InformacaoChamadaAluno({Key? key, required this.historico_turma})
      : super(key: key);

  @override
  State<InformacaoChamadaAluno> createState() => _InformacaoChamadaAlunoState();
}

class _InformacaoChamadaAlunoState extends State<InformacaoChamadaAluno> {
  @override
  Widget build(BuildContext context) {
    HistoricoInformacaoTurma historico_turma = widget.historico_turma;
    var hora_encerramento = somarHoraComDuracao(
        historico_turma.hora_comeco, historico_turma.duracao);
    return Scaffold(
        backgroundColor: Color(0xFFE1F4FE),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: DefaultAppBar(titleAppBar: "Chamada ${historico_turma.data}"),
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.all(20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              "Informações da Chamada",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Data:${historico_turma.data}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
            Text("Inicio: ${historico_turma.hora_comeco}",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
            Text("Encerramento: ${hora_encerramento}",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
            SizedBox(
              height: 30,
            ),
            Text(
              "Sua Presença",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 20,
            ),
            FutureBuilder(
                future: presenca_aluno(
                    historico_turma.chamada_id, historico_turma.class_id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Erro: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    List dado = snapshot.data as List;
                    PresencaAluno presenca = dado[0];
                    return Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            Text("Estado:",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w400)),
                            SizedBox(
                              width: 100,
                            ),
                            Container(
                              width: 120,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(presenca.presenca,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400)),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            Text("Tempo Restante:",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w400)),
                            SizedBox(
                              width: 15,
                            ),
                            Container(
                              width: 120,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("0",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400)),
                              ),
                            )
                          ],
                        ),
                      ],
                    );
                  }
                  return Container();
                })
          ]),
        )));
  }
}

String somarHoraComDuracao(String hora, int duracaoEmSegundos) {
  if (hora == "Sem hora especificada") {
    return hora;
  }
  // Converter a string de hora para um objeto DateTime
  DateTime horaAtual = DateTime.parse("1970-01-01 $hora");

  // Adicionar a duração em segundos
  DateTime novaHora = horaAtual.add(Duration(seconds: duracaoEmSegundos));

  // Formatar a nova hora como uma string no formato desejado
  String novaHoraFormatada =
      "${novaHora.hour.toString().padLeft(2, '0')}:${novaHora.minute.toString().padLeft(2, '0')}:${novaHora.second.toString().padLeft(2, '0')}";

  return novaHoraFormatada;
}
