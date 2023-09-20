// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';

import 'tela_login.dart';

class TelaAutentificacao extends StatelessWidget {
  const TelaAutentificacao({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE1F4FE),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Image.asset('assets/logo.png')),
          SizedBox(
            height: 200,
          ),
          ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext) {
                    return TelaLogin();
                  },
                );
              },
              child: Text(
                'Entrar com idUFF',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ))
        ],
      ),
    );
  }
}
