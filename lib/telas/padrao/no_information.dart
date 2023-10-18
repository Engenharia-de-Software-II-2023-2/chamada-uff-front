// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import '../../widgets/padrao/app_bar.dart';



class NoInformation extends StatelessWidget {
  final String message;
  final String titleAppBar;
  NoInformation({Key? key, required this.message, required this.titleAppBar}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: DefaultAppBar(titleAppBar: "Turmas"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: ListTile(
                  title: Text(message, style: const TextStyle(fontSize: 20)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
