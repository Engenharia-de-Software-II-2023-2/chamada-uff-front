import 'package:flutter/material.dart';
import '../models/classroom.dart';
import '../widgets/class/item.dart';

class ClassListScreen extends StatelessWidget {
  final List<Classroom> classrooms;

  ClassListScreen(this.classrooms);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Turmas'),
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
