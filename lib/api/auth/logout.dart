import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import '../../telas/autentificacao/tela_autentificacao.dart';

class Logout {
  void performLogout(BuildContext context) async{
    final storage = FlutterSecureStorage();
    await storage.delete(key: 'id');
    await storage.delete(key: 'token');
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const TelaAutentificacao(),
      ),
    );
  }
}


