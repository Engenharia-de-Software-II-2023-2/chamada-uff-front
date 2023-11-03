import 'package:flutter/material.dart';
import '../../modelos/attendance.dart';
import '../../modelos/classroom.dart';
import '../../widgets/padrao/app_bar.dart';
import 'package:provider/provider.dart';
import '../../providers/switch_provider.dart';
import '../../api/attendance/manager_attendance.dart';
import '../../widgets/turmas/turma_switch.dart';

class ClassroomDetailScreen extends StatefulWidget {
  final Classroom classroom;
  ClassroomDetailScreen({Key? key, required this.classroom}) : super(key: key);
  bool autoAttendance = false;
  bool isFirstTimeSwitchActivated = true;




  @override
  _ClassroomDetailScreenState createState() => _ClassroomDetailScreenState();
}

class _ClassroomDetailScreenState extends State<ClassroomDetailScreen> {
  bool _isCollapsed = true;
  Attendance attendance = Attendance();
  List<String> weekDays = ['Segunda', 'Terça', 'Quarta', 'Quinta', 'Sexta', 'Sábado', 'Domingo'];
  String selectedWeekDay = '';
  bool aluno = false;
  bool isCallActive = false; // Variável para controlar se há uma chamada ativa

  @override
  void initState() {
    super.initState();
    checkActiveCall();
  }

  Future<void> checkActiveCall() async {
    // Substitua este trecho com a chamada real para verificar a chamada ativa
    bool hasActiveCall = await ManagerAttendance.checkActiveCall(widget.classroom.id);
    setState(() {
      isCallActive = hasActiveCall;
    });
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
                  // Navegue para a página de histórico da turma
                  // Substitua '/historicoTurma' pela rota correta
                  Navigator.of(context).pushNamed('/historicoTurma');
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
              if (_isCollapsed && aluno == false) ...[
                for (int index = 0; index < switchProvider.classrooms.length; index++)  // Use switchProvider em vez de SwitchProvider
                  ListTile(
                    title: Text('Iniciar chamada'),
                    trailing: ClassroomSwitch.buildSwitch(index, widget.isFirstTimeSwitchActivated),
                  ),
              ],
              if (aluno == true) ...[
                SizedBox(height: 50),
                ElevatedButton(
                  onPressed: isCallActive ?  ManagerAttendance.markAttendance : null,
                  child: Text("Marcar Presença"),
                  style: ElevatedButton.styleFrom(minimumSize: Size(200, 80)),
                ),
                if (isCallActive) ...[
                  Text("Pressione o botão para marcar presença."),
                ] else ...[
                  Text("Não há chamadas abertas para essa turma no momento."),
                ],
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


