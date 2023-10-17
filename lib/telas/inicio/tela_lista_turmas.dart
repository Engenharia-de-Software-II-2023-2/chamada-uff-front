// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import '../../modelos/classroom.dart';
import '../../widgets/turmas/item.dart';
import '../../api/api_service.dart';


class ClassListScreen extends StatelessWidget {
  final List<Classroom> classrooms;
  final AuthService authService = AuthService();

  ClassListScreen({Key? key, required this.classrooms}) : super(key: key);

  void _performLogout(BuildContext context)  {
    authService.performLogout(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text('Turmas'),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.logout), // Ícone de logout (substitua pelo ícone desejado)
                onPressed: () {
                  _performLogout(context); // Função para executar o logout
                },
              ),
            ],
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
