import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/switch_provider.dart';
import '../../api/attendance/manager_attendance.dart';

class ClassroomSwitch {
  static Widget buildSwitch(int index, bool isFirstTimeSwitchActivated) {
    return Consumer<SwitchProvider>(
      builder: (context, switchProvider, child) {
        return Switch(
          value: switchProvider.classrooms[index].isSwitchOn,
          onChanged: (value) async {
            switchProvider.toggleSwitch(index);
            if (value) {
              if (isFirstTimeSwitchActivated) {
                final bool createResponse = await ManagerAttendance.createAttendance(widget.classroom.id);
                if (createResponse) {
                  final bool controlResponse = await ManagerAttendance.controlAttendance();
                  if (controlResponse) {
                    isFirstTimeSwitchActivated = false; // Marque que não é mais a primeira vez
                  } else {
                    value = !value;
                  }
                } else {
                  value = !value;
                }
              } else {
                final bool controlResponse = await ManagerAttendance.controlAttendance();
                if (!controlResponse) {
                  value = !value;
                }
              }
            } else {
              final bool controlResponse = await ManagerAttendance.controlAttendance();
              if (!controlResponse) {
                value = !value;
              }
            }
          },
        );
      },
    );
  }
}
