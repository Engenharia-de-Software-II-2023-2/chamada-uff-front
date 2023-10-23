import 'package:chamada_inteligente/modelos/attendance.dart';
import 'package:chamada_inteligente/modelos/classroom.dart';
import 'package:flutter/material.dart';
// import '../models/classroom.dart';
// import '../models/attendance.dart';

class ClassroomDetailScreen extends StatefulWidget {
  final Classroom classroom;
  ClassroomDetailScreen(this.classroom);
  bool autoAttendance = false;

  @override
  _ClassroomDetailScreenState createState() => _ClassroomDetailScreenState();
}

class _ClassroomDetailScreenState extends State<ClassroomDetailScreen> {
  bool _isCollapsed = true;
  Attendance attendance = Attendance();
  List<String> weekDays = ['Segunda', 'Terça', 'Quarta', 'Quinta', 'Sexta', 'Sábado', 'Domingo'];
  String selectedWeekDay = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Informações da Turma'),
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
              if (_isCollapsed) ...[
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
