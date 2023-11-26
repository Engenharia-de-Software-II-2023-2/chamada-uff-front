// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'telas/autentificacao/tela_autentificacao.dart';
import 'providers/switch_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<SwitchProvider>(create: (context) => SwitchProvider()),
      ],
      child: MaterialApp(home: TelaAutentificacao()),
    ),
  );
}







