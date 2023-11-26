import 'package:flutter/material.dart';
import '../../api/auth/logout.dart';

class DefaultAppBar extends StatelessWidget {
  final String titleAppBar;
  final Logout logout = Logout();
  DefaultAppBar({Key? key, required this.titleAppBar}) : super(key: key);

  void _performLogout(BuildContext context)  {
    logout.performLogout(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text(titleAppBar),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout), // Ícone de logout (substitua pelo ícone desejado)
            onPressed: () {
              _performLogout(context); // Função para executar o logout
            },
          ),
        ],
      ),
    );
  }
}
