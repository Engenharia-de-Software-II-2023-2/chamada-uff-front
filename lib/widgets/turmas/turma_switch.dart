import 'package:flutter/material.dart';

import '../../api/attendance/manager_attendance.dart';

class ClassroomSwitch {
  static Widget buildSwitch(bool isFirstTimeSwitchActivated, bool initialValue, int classroomId) {
    return Switch(
      value: initialValue,
      onChanged: (initialValue) async {
          print(initialValue.toString());
          if (isFirstTimeSwitchActivated) {
            final bool createResponse = await ManagerAttendance.createAttendance(classroomId);
            if (createResponse) {
              final bool controlResponse = await ManagerAttendance.controlAttendance();
              if (controlResponse) {
                initialValue = await ManagerAttendance.checkActiveCall(classroomId);
                isFirstTimeSwitchActivated = false; // Marque que não é mais a primeira vez
              } else {
                initialValue = await ManagerAttendance.checkActiveCall(classroomId);
              }
            } else {
              initialValue = await ManagerAttendance.checkActiveCall(classroomId);
            }
          } else {
            final bool controlResponse = await ManagerAttendance.controlAttendance();
              initialValue = await ManagerAttendance.checkActiveCall(classroomId);
          }
        }
    );
  }
}
