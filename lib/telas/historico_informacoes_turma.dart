// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:chamada_inteligente/modelos/historico_informacao_turma.dart';
import 'package:chamada_inteligente/telas/informacao_chamada.dart';
import 'package:chamada_inteligente/widgets/padrao/app_bar.dart';
import 'package:flutter/material.dart';

List<HistoricoInformacaoTurma> instancia_historico() {
  List<HistoricoInformacaoTurma> historicos = [];
  for (int i = 0; i < 5; i++) {
    HistoricoInformacaoTurma historico =
        HistoricoInformacaoTurma("2023/11/0$i", "08:00", "09:30", i);
    historicos.add(historico);
  }
  return historicos;
}

class HistoricoChamada extends StatefulWidget {
  const HistoricoChamada({super.key});

  @override
  State<HistoricoChamada> createState() => _HistoricoChamadaState();
}

class _HistoricoChamadaState extends State<HistoricoChamada> {
  List<HistoricoInformacaoTurma> historico = instancia_historico();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE1F4FE),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: DefaultAppBar(titleAppBar: "Histórico"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "Chamadas",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
              ),
            ),
            for (var index = 0; index < historico.length; index++)
              Padding(
                padding:
                    EdgeInsets.only(top: 7.0, left: 20, right: 20, bottom: 7.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  child: Expanded(
                    child: ListTile(
                      title: Text(historico[index].data),
                      trailing: Text(
                          "${historico[index].hora_comeco} - ${historico[index].hora_fim}"),
                      onTap: () {
                        // chamada_id: historico[index].chamada_id,
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => InformacaoChamada()));
                      },
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
