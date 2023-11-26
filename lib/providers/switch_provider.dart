import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../modelos/classroom.dart';

class SwitchProvider with ChangeNotifier {
  List<Classroom> classrooms = [];

  void updateClassroomsList(List<Classroom> newClassroomsList) {
    classrooms = newClassroomsList;
    notifyListeners(); // Notifique os ouvintes que os dados foram atualizados
  }

  void toggleSwitch(int index) {
    classrooms[index].isSwitchOn = !classrooms[index].isSwitchOn;
    notifyListeners();
  }
}