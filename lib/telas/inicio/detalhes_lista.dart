// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:chamada_inteligente/telas/historico_informacoes_turma.dart';
import 'package:chamada_inteligente/telas/informacao_chamada_professor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../modelos/attendance.dart';
import '../../modelos/classroom.dart';
import '../../widgets/padrao/app_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<bool> verifica_aluno() async {
  final role = await FlutterSecureStorage().read(key: 'role');
  if (role == "STUDENT") {
    return true;
  } else {
    return false;
  }
}

Future<bool> criar_chamada() async {
  final token = await FlutterSecureStorage().read(key: 'token');
  final class_id = 4;
  final jsonData =
        json.encode({"classId": 1});
  final url = Uri.parse(
      'https://engsoft2grupo3api.azurewebsites.net/attendance/createAttendance');
  final response = await http.post(url, headers: {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json'
  },body: jsonData);
  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

// Future<bool> checa_chamada() async {
//   final token = await FlutterSecureStorage().read(key: 'token');
//   final class_id = 4;
//   final url = Uri.parse(
//       'https://engsoft2grupo3api.azurewebsites.net/attendance/findAttendancesByClassId/$class_id');
//   final response = await http.post(url, headers: {
//     'Authorization': 'Bearer $token',
//     'Content-Type': 'application/json'
//   });
//   if (response.statusCode == 200) {
//     return true;
//   } else {
//     return false;
//   }
// }

class ClassroomDetailScreen extends StatefulWidget {
  final Classroom classroom;
  ClassroomDetailScreen({Key? key, required this.classroom}) : super(key: key);
  bool autoAttendance = false;
  @override
  _ClassroomDetailScreenState createState() => _ClassroomDetailScreenState();
}

class _ClassroomDetailScreenState extends State<ClassroomDetailScreen> {
  String confirm_presence = "";
  bool botaoDesabilitado =
      false; // Inicialize com um valor padrão, pois não pode depender de widget diretamente

  @override
  void initState() {
    super.initState();

    // Inicialize botaoDesabilitado com base na lógica desejada aqui
    botaoDesabilitado = widget.classroom.classCode == 'A1' ? true : false;
  }

  bool _isCollapsed = true;
  Attendance attendance = Attendance();
  List<String> weekDays = [
    'Segunda',
    'Terça',
    'Quarta',
    'Quinta',
    'Sexta',
    'Sábado',
    'Domingo'
  ];
  String selectedWeekDay = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: DefaultAppBar(titleAppBar: "Informações da Turma"),
      ),
      body: FutureBuilder(
          future: verifica_aluno(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Erro: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 50.0, left: 10.0, right: 10.0, bottom: 20.0),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(widget.classroom.name,
                            style: const TextStyle(fontSize: 20)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.classroom.classCode,
                                style: const TextStyle(fontSize: 16)),
                            Text(widget.classroom.classTime,
                                style: const TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        HistoricoChamada(class_id: widget.classroom.id)));
                        },
                        child: Text('Histórico da Turma'),
                      ),
                      ListTile(
                        title: const Text('Configurações de Chamada',
                            style: TextStyle(fontSize: 24)),
                      ),
                      Container(
                        padding: EdgeInsets.all(0.5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 3,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListTile(
                          title: Text(_isCollapsed ? 'Manual' : 'Automática',
                              style: TextStyle(fontSize: 16)),
                          onTap: () {
                            setState(() {
                              _isCollapsed = !_isCollapsed;
                            });
                          },
                          trailing: Icon(
                            _isCollapsed
                                ? Icons.expand_more
                                : Icons.expand_less,
                          ),
                        ),
                      ),
                      if (_isCollapsed && snapshot.data == false) ...[
                        ListTile(
                          title: Text('Iniciar chamada'),
                          trailing: Switch(
                            value: widget.autoAttendance,
                            onChanged: (value) {
                              setState(() {
                                widget.autoAttendance = value;
                              });
                            },
                          ),
                        ),
                      ],
                      if (widget.autoAttendance == true) ...[
                        FutureBuilder(
                            future: criar_chamada(),
                            builder: ((context, snapshot2) {
                              if (snapshot2.hasData) {
                                if (snapshot2.data == true) {
                                  return Text("Chamada criada!", style: TextStyle(color: Colors.green),);
                                } else {
                                  return Text("Chamada não criada",style: TextStyle(color: Colors.red));
                                }
                              } else {
                                return Text("Esperando...",style: TextStyle(color: Colors.blue));
                              }
                            }))
                      ],
                      if (snapshot.data == true) ...[
                        SizedBox(
                          height: 50,
                        ),
                        ElevatedButton(
                            onPressed: botaoDesabilitado
                                ? null
                                : () {
                                    setState(() {
                                      confirm_presence = "Presença Registrada!";
                                    });
                                  },
                            child: Text("Marcar Presença"),
                            style: ElevatedButton.styleFrom(
                                disabledBackgroundColor: Colors.grey,
                                minimumSize: Size(200, 80))),
                        Text(confirm_presence, style: TextStyle(color: Colors.green),),
                      ],
                      if (!_isCollapsed) ...[
                        ListTile(
                          title: Text('Dia da Chamada',
                              style: TextStyle(fontSize: 20)),
                        ),
                        ListView.separated(
                          shrinkWrap: true,
                          itemCount: weekDays.length,
                          separatorBuilder: (context, index) {
                            return Divider(height: 1, color: Colors.grey);
                          },
                          itemBuilder: (context, index) {
                            final weekDay = weekDays[index];
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedWeekDay = weekDay;
                                });
                              },
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 3,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  padding: EdgeInsets.all(16.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(weekDay),
                                      if (selectedWeekDay == weekDay)
                                        Icon(Icons.check_circle,
                                            color: Colors.green),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          title: Padding(
                            padding: const EdgeInsets.only(
                                top: 8.0,
                                bottom:
                                    8.0), // Adicione o padding apenas na parte inferior
                            child: Text('Horário da Chamada',
                                style: TextStyle(fontSize: 20)),
                          ),
                        ),
                        ListTile(
                          title: Container(
                            padding: EdgeInsets.all(1.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 3,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: GestureDetector(
                                onTap: () async {
                                  TimeOfDay? selectedTime =
                                      await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  );

                                  if (selectedTime != null) {
                                    String formattedTime =
                                        selectedTime.format(context);
                                    setState(() {
                                      attendance.start = formattedTime;
                                    });
                                  }
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.access_time), // Ícone de relógio
                                    SizedBox(width: 8.0),
                                    Text(
                                      attendance.start,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            } else {
              return Center(child: Text('Aguardando resultado...'));
            }
          }),
    );
  }
}
