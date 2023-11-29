// ignore_for_file: prefer_const_constructors_in_immutables, prefer_typing_uninitialized_variables, prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, unused_local_variable

import 'dart:convert';

import 'package:chamada_inteligente/telas/informacao_chamada_aluno.dart';
import 'package:chamada_inteligente/widgets/padrao/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../modelos/historico_informacao_turma.dart';
import '../modelos/presenca_chamada_professor.dart';

Future<List> historico_presenca(chamada_id) async {
  final token = await FlutterSecureStorage().read(key: 'token');
  final jsonData = json.encode({"attendanceId": chamada_id});
  List alunos = [];
  var url = Uri.parse(
      'https://engsoft2grupo3api.azurewebsites.net/response/attendanceResponse');
  var headers = {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json'
  };
  var response = await http.post(url, headers: headers, body: jsonData);
  //todo:desmockar
  if (response.statusCode == 200) {
    List inativos = json.decode(response.body)['absent'];
    List ativos = json.decode(response.body)['present'];
    for (var aluno_atual in inativos) {
      PresencaChamadaProfessor presenca = PresencaChamadaProfessor(
          chamada_id: 1,
          aluno_id: 1,
          id: 1,
          inicio_chamada: "inicio_chamada",
          final_chamada: "final_chamada",
          presenca: false);
      presenca.nome_aluno = aluno_atual['name'];
      alunos.add(presenca);
    }
    for (var aluno_atual in ativos) {
      PresencaChamadaProfessor presenca = PresencaChamadaProfessor(
          chamada_id: 1,
          aluno_id: 1,
          id: 1,
          inicio_chamada: "inicio_chamada",
          final_chamada: "final_chamada",
          presenca: true);
      presenca.nome_aluno = aluno_atual['name'];
      alunos.add(presenca);
    }
  }
  return alunos;
}

class InformacaoChamadaProfessor extends StatefulWidget {
  final historico_turma;
  InformacaoChamadaProfessor({Key? key, required this.historico_turma})
      : super(key: key);

  @override
  State<InformacaoChamadaProfessor> createState() =>
      _InformacaoChamadaProfessorState();
}

class _InformacaoChamadaProfessorState
    extends State<InformacaoChamadaProfessor> {
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
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Informações da Chamada",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Data:${historico_turma.data}",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                    ),
                    Text("Inicio: ${historico_turma.hora_comeco}",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w400)),
                    // Text("Encerramento: ${hora_encerramento}",
                    //     style: TextStyle(
                    //         fontSize: 20, fontWeight: FontWeight.w400)),
                    SizedBox(
                      height: 30,
                    ),
                    
                    FutureBuilder(
                        future:
                            historico_presenca(widget.historico_turma.chamada_id),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Erro: ${snapshot.error}'));
                          } else if (snapshot.hasData) {
                            List alunos_presentes = [];
                            List alunos_ausentes = [];
                            List todos_alunos = snapshot.data as List;
                            for (var aluno in todos_alunos) {
                              if (aluno.presenca == false) {
                                alunos_ausentes.add(aluno);
                              } else {
                                alunos_presentes.add(aluno);
                              }
                            }
                            return Column(
                              children: [
                                Text(
                                  "Alunos Presentes",
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                for (var aluno in alunos_presentes)
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 7.0,
                                        left: 20,
                                        right: 20,
                                        bottom: 7.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        _mostrarPopup(
                                            context, aluno.nome_aluno);
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8.0)),
                                        ),
                                        child: Expanded(
                                          child: ListTile(
                                            title: Text(aluno.nome_aluno),
                                            trailing: Icon(Icons.edit_square),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                SizedBox(
                                  height: 30,
                                ),
                                Text(
                      "Alunos Ausentes",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    for (var aluno in alunos_ausentes)
                      Padding(
                        padding: EdgeInsets.only(
                            top: 7.0, left: 20, right: 20, bottom: 7.0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                          child: Expanded(
                            child: ListTile(
                              title: Text(aluno.nome_aluno),
                              trailing: Icon(Icons.info),
                              onTap: () {
                                // chamada_id: historico[index].chamada_id,
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => InformacaoChamadaProfessor()));
                              },
                            ),
                          ),
                        ),
                      ),
                              ],
                            );
                          }
                          return Container();
                        }),
                  ])),
        ));
  }
}

void _mostrarPopup(BuildContext context, String alunoNome) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Detalhes do Aluno'),
        content: Text('Nome do Aluno: $alunoNome'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Fechar'),
          ),
        ],
      );
    },
  );
}
