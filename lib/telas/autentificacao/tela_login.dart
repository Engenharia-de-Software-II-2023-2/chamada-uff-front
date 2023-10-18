import 'package:chamada_inteligente/modelos/classroom.dart';
import 'package:flutter/material.dart';
import '../inicio/tela_lista_turmas.dart';
import '../../api/api_service.dart';

class TelaLogin extends StatelessWidget {
  const TelaLogin({Key? key}) : super (key: key);
  //const GlobalKey<ScaffoldState> _scaffoldKey =  const GlobalKey<ScaffoldState>();
  final TextEditingController loginController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  static const AuthService authService = AuthService();

  Future<void> _onLoginButtonPressed(BuildContext context) async {
    final result = await authService.doLogin(
      loginController.text,
      senhaController.text,
    );

    if (result == true) {
      try {
        final List<Classroom> classes = await authService.getClassList(1);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ClassListScreen(classrooms: classes),
          ),
        );
      } catch (e) {
        // Trate possíveis erros ao obter a lista de classes aqui.
        print('Erro ao obter a lista de classes: $e');
      }
    } else {
      // A requisição falhou.
      // Exibir uma mensagem de erro usando um SnackBar.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Usuário ou senha inválido'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text('Fazer Login'),
        actions: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.center,
              child: Text(
                'Cancelar',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Column(
                children: [
                  SizedBox(
                    width: 250,
                    height: 100,
                    child: TextField(
                      controller: loginController,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Login',
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 250,
                    height: 100,
                    child: TextField(
                      controller: senhaController,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Senha',
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _onLoginButtonPressed(context);
                    },
                    child: Text('Login', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
