import 'package:chamada_inteligente/modelos/classroom.dart';
import 'package:flutter/material.dart';
import '../inicio/tela_lista_turmas.dart';
import '../../api/auth/login.dart';
import '../padrao/no_information.dart';
import '../../api/classes/class-list.dart';


class TelaLogin extends StatelessWidget {
  final TextEditingController loginController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final AuthService authService = AuthService();


  Future<void> _onLoginButtonPressed(BuildContext context) async {
    final result = await authService.doLogin(
      loginController.text,
      senhaController.text,
    );

    if (result == true) {
      try {
        final List<Classroom> classes = await getClassList();
        Navigator.pushAndRemoveUntil(
          context,
        MaterialPageRoute(
          builder: (context) => ClassListScreen(classrooms: classes),
          ),
          (Route<dynamic> route) => false,
        );
      } catch (e) {
        // Trate possíveis erros ao obter a lista de classes aqui.
        print('Erro ao obter a lista de classes: $e');
        final errorMessage = e.toString();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => NoInformation(message: "Não há inscrição de turmas nesse período", titleAppBar: "Turmas"),
          ),
              (Route<dynamic> route) => false,
        );
      }
    } else {
      print('Não vou chamar as listas');
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

        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Column(
                  children: [
                    SizedBox(
                      width: 250,
                      height: 100,
                      child: TextFormField(
                        controller: loginController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Login',
                        ),
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    SizedBox(
                      width: 250,
                      height: 100,
                      child: TextFormField(
                        controller: senhaController,
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Senha',
                        ),
                        onFieldSubmitted: (value) {
                          _onLoginButtonPressed(context);
                        }
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
      ),
    );
  }
}
