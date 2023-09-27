import 'package:chamada_inteligente/helpers/salas_de_aula_dummy.dart';
import 'package:flutter/material.dart';
import '../../modelos/classroom.dart';
import '../../telas/inicio/detalhes_lista.dart';

class ClassItem extends StatelessWidget {
  final Classroom classroom;

  ClassItem(this.classroom);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 7.0, left: 10.0, right: 10.0, bottom: 7.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, // Cor de fundo do retângulo branco
          borderRadius:
              BorderRadius.all(Radius.circular(8.0)), // Borda arredondada
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 3,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          title: Text(
            classroom.name,
            style: TextStyle(fontSize: 20),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                classroom.classCode,
                style: TextStyle(fontSize: 16),
              ),
              Text(
                classroom.classTime,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          trailing: classroom.activeClass
              ? Icon(Icons.check_circle, color: Colors.green)
              : null,
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ClassroomDetailScreen(classroom:classroom)));
          },
        ),
      ),
    );
  }
}
