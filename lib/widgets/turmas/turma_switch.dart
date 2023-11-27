import 'package:flutter/material.dart';
import '../../api/attendance/manager_attendance.dart';

class ClassroomSwitch extends StatefulWidget {
  final int classroomId;

  const ClassroomSwitch({
    Key? key,
    required this.classroomId,
  }) : super(key: key);

  @override
  _ClassroomSwitchState createState() => _ClassroomSwitchState();
}

class _ClassroomSwitchState extends State<ClassroomSwitch> {
  bool _isFirstTimeSwitchActivated = false;
  bool _initialValue = false;

  @override
  void initState() {
    super.initState();
    _initSwitchState();
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: _initialValue,
      onChanged: (value) {
        _handleSwitchChange(value);
      },
    );
  }

  Future<void> _handleSwitchChange(bool value) async {
    if (_isFirstTimeSwitchActivated) {
      print('primeira vez abrindo chamada');
      final bool createResponse = await ManagerAttendance.createAttendance(
          widget.classroomId);
      if (createResponse) {
        print('chamada aberta');
        final bool controlResponse = await ManagerAttendance
            .controlAttendance();
        if (controlResponse) {
          print('chamada ativada, checando status');
          await _updateSwitchState();
        } else {
          print('erro ao abrir chamada, checando status');
          await _updateSwitchState(); // Adicione uma função para atualizar o estado do switch
        }
      } else {
        await _updateSwitchState(); // Adicione uma função para atualizar o estado do switch
      }
    } else {
      final bool controlResponse = await ManagerAttendance.controlAttendance();
      if (controlResponse) {
        print('chamada ativada, checando status');
        await _updateSwitchState(); // Adicione uma função para atualizar o estado do switch
      } else {
        print('erro ao abrir chamada, checando status');
        await _updateSwitchState(); // Adicione uma função para atualizar o estado do switch
      }
    }
  }

// Função para atualizar o estado do switch
  Future<void> _updateSwitchState() async {
    final bool activeCall = await ManagerAttendance.checkActiveCall(widget.classroomId);

    setState(() {
      _initialValue = activeCall;
      _isFirstTimeSwitchActivated = false;
    });
    print(_isFirstTimeSwitchActivated);
    print(_initialValue);
  }

// Função para atualizar o estado do switch
  Future<void> _initSwitchState() async {
    final bool activeCall = await ManagerAttendance.checkActiveCall(widget.classroomId);
    setState(() {
      _isFirstTimeSwitchActivated = !activeCall;
      _initialValue = activeCall;
    });
    print(_isFirstTimeSwitchActivated);
    print(_initialValue);
  }
}
