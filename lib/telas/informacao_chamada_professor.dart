// ignore_for_file: prefer_const_constructors_in_immutables, prefer_typing_uninitialized_variables, prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names

import 'dart:convert';

import 'package:chamada_inteligente/widgets/padrao/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

Future<bool> historico_presenca(chamada_id) async {
  final token = await FlutterSecureStorage().read(key: 'token');
  var url = Uri.parse(
      'https://engsoft2grupo3api.azurewebsites.net/response/attendanceResponse?attendanceId=$chamada_id');
  var headers = {'Authorization': 'Bearer $token'};
  var response = await http.get(url, headers: headers);
  var a = 3;
  a + 1;
  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

class InformacaoChamadaProfessor extends StatefulWidget {
  final historico_turma;
  InformacaoChamadaProfessor({Key? key, required this.historico_turma})
      : super(key: key);

  @override
  State<InformacaoChamadaProfessor> createState() => _InformacaoChamadaProfessorState();
}

class _InformacaoChamadaProfessorState extends State<InformacaoChamadaProfessor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFE1F4FE),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: DefaultAppBar(titleAppBar: "Chamada 08/11/2023"),
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
                      "Data:30/10/2023",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                    ),
                    Text("Inicio: 9:00",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w400)),
                    Text("Encerramento: 11:00",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w400)),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Alunos Presentes",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    for (var index = 0; index < 3; index++)
                      Padding(
                        padding: EdgeInsets.only(
                            top: 7.0, left: 20, right: 20, bottom: 7.0),
                        child: GestureDetector(
                          onTap: () {
                            _mostrarPopup(context, "Vinicius Silva");
                          },
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                            ),
                            child: Expanded(
                              child: ListTile(
                                title: Text("João Silva"),
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
                    for (var index = 0; index < 3; index++)
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
                              title: Text("Vinicius Silva"),
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
                    // FutureBuilder(
                    //     future:
                    //         historico_presenca(widget.historico_turma.class_id),
                    //     builder: (context, snapshot) {
                    //       if (snapshot.connectionState ==
                    //           ConnectionState.waiting) {
                    //         return Center(child: CircularProgressIndicator());
                    //       } else if (snapshot.hasError) {
                    //         return Center(
                    //             child: Text('Erro: ${snapshot.error}'));
                    //       } else if (snapshot.hasData) {
                    //         return Container();
                    //       }
                    //       return Container();
                    //     }),
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
