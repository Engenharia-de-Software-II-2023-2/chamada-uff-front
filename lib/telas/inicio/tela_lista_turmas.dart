// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import '../../modelos/classroom.dart';
import '../../widgets/turmas/item.dart';
import '../../widgets/padrao/app_bar.dart';



class ClassListScreen extends StatelessWidget {
  final List<Classroom> classrooms;
  ClassListScreen({Key? key, required this.classrooms}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: DefaultAppBar(titleAppBar: "Turmas"),
      ),
      body: Container(
        color: Colors.blue[50],
        child: Padding(

        padding: const EdgeInsets.only(top: 50.0),
        child: ListView.builder(
        itemCount: classrooms.length,
        itemBuilder: (ctx, index) {
          return ClassItem(classrooms[index]);
            },
          ),
        ),
      ),
    );
  }
}
