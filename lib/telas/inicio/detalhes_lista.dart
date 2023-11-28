import 'package:flutter/material.dart';
import '../../modelos/attendance.dart';
import '../../modelos/classroom.dart';
import '../../widgets/padrao/app_bar.dart';
import 'package:provider/provider.dart';
import '../../providers/switch_provider.dart';
import '../../api/attendance/manager_attendance.dart';
import '../../widgets/turmas/turma_switch.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:async';
import '../historico_informacoes_turma.dart';


class ClassroomDetailScreen extends StatefulWidget {
  final Classroom classroom;
  ClassroomDetailScreen({Key? key, required this.classroom}) : super(key: key);
  bool autoAttendance = false;





  @override
  _ClassroomDetailScreenState createState() => _ClassroomDetailScreenState();
}

class _ClassroomDetailScreenState extends State<ClassroomDetailScreen> {
  bool _isCollapsed = true;
  Attendance attendance = Attendance(professorLatitude: 11, professorLongitude: 22);
  List<String> weekDays = ['Segunda', 'Terça', 'Quarta', 'Quinta', 'Sexta', 'Sábado', 'Domingo'];
  String selectedWeekDay = '';
  bool aluno = false;
  bool prof = false;
  bool isCallActive = false; // Variável para controlar se há uma chamada ativa
  bool attendanceResult = false; // Variável que informa se o aluno já registrou presença
  bool inRadio = false; // Variável que informa se o aluno está no raio da sala de aula
  String attendanceText = 'Texto padrão por enquanto';
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _initializeScreen();
  }

  void _checkAndSetIsCallActive(Timer timer) async {
    final newIsCallActive = await checkActiveCall();

    if (newIsCallActive) {
      setState(() {
        isCallActive = true;
      });

      // Cancela o timer, pois não é mais necessário
      _timer.cancel();
    }
  }

  // Função para iniciar o timer
  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 20), _checkAndSetIsCallActive);
  }
  // Função para parar o timer
  void _stopTimer() {
    if (_timer.isActive) {
      _timer.cancel();
    }
  }

  Future<void> _initializeScreen() async {
    try {
      final attendanceStatus = await checkActiveCall();
      final actualRole = await checkRole();

      if (actualRole == 'STUDENT') {
        setState(() {
          aluno = true;
          prof = false;
        });

        if (attendanceStatus) {
          final hasResponded = await ManagerAttendance.checkResponse();

          if (hasResponded) {
            setState(() {
              attendanceResult = true;
              attendanceText = "Presença confirmada!";
            });
          } else {
            setState(() {
              attendanceText = "Pressione o botão para marcar presença.";
            });
          }
        } else {
          setState(() {
            attendanceText = "Não há chamadas abertas para esta turma.";
          });
        }
      } else if (actualRole == 'PROFESSOR') {
        setState(() {
          aluno = false;
          prof = true;
        });
      }

      if (!attendanceStatus) {
        _startTimer();
      }
      setState(() {
        isCallActive = attendanceStatus;
      });
    } catch (e) {
      // Trate exceções aqui, por exemplo, logando ou relançando para a camada superior.
      print("Erro em _initializeScreen: $e");
    }
  }

  @override
  void dispose() {
    // Garanta que o timer seja cancelado quando o widget for descartado
    _stopTimer();
    super.dispose();
  }


  Future<bool> checkActiveCall() async {
    final hasActiveCall = await ManagerAttendance.checkActiveCall(widget.classroom.id);
    return hasActiveCall;
  }

  Future<String> checkRole() async {
    final storage = FlutterSecureStorage();
    final role = await storage.read(key: 'role');
    if (role != null) {
      return role;
    } else {
      throw Exception("Chave 'role' não encontrada no armazenamento seguro.");
    }
  }

  Future<void> markAttendance() async {
    final bool radio =  await ManagerAttendance.checkRadio();
    if(radio){
      final bool attendance = await ManagerAttendance.markAttendance();
      final hasResponded = await ManagerAttendance.checkResponse();
      if(hasResponded){
        print("presença confirmada");
        setState(() {
          attendanceText = "Presença confirmada!";
          attendanceResult = true;
        });
      }
    } else{
      print("fora do raio");
      setState(() {
        attendanceText = "Você não está no raio da sala de aula";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final switchProvider = Provider.of<SwitchProvider>(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: DefaultAppBar(titleAppBar: "Informações da Turma"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0, left: 10.0, right: 10.0, bottom: 20.0),
          child: Column(
            children: [
              ListTile(
                title: Text(widget.classroom.name, style: const TextStyle(fontSize: 20)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.classroom.classCode, style: const TextStyle(fontSize: 16)),
                    Text(widget.classroom.classTime, style: const TextStyle(fontSize: 16)),
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
                title: const Text('Configurações de Chamada', style: TextStyle(fontSize: 24)),
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
                  title: Text(_isCollapsed ? 'Manual' : 'Automática', style: TextStyle(fontSize: 16)),
                  onTap: () {
                    setState(() {
                      _isCollapsed = !_isCollapsed;
                    });
                  },
                  trailing: Icon(
                    _isCollapsed ? Icons.expand_more : Icons.expand_less,
                  ),
                ),
              ),
              if (_isCollapsed && prof == true) ...[
                  ListTile(
                    title: Text('Iniciar chamada'),
                    trailing: ClassroomSwitch(
                      classroomId: widget.classroom.id
                    ),
                  ),
              ],
              if (aluno == true) ...[
                SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () async {
                    if (isCallActive && !attendanceResult) {
                      await markAttendance();
                    }
                  },
                  child: Text("Marcar Presença"),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(200, 80),
                    // Desativar o botão quando a presença já foi confirmada
                    backgroundColor: attendanceResult ? Colors.grey : null,
                  ),
                ),
                Text(attendanceText),
              ],

              if (!_isCollapsed) ...[
                ListTile(
                  title: Text('Dia da Chamada', style: TextStyle(fontSize: 20)),
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
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(weekDay),
                              if (selectedWeekDay == weekDay)
                                Icon(Icons.check_circle, color: Colors.green),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                ListTile(
                  title: Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0), // Adicione o padding apenas na parte inferior
                    child: Text('Horário da Chamada', style: TextStyle(fontSize: 20)),
                    ),
                  ),
                ListTile(
                  title: Container(
                    padding: EdgeInsets.all(1.0),
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: GestureDetector(
                        onTap: () async {
                          TimeOfDay? selectedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );

                          if (selectedTime != null) {
                            String formattedTime = selectedTime.format(context);
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
      ),
    );
  }
}


