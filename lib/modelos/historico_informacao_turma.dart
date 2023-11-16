class HistoricoInformacaoTurma {
  final String data;
  final String hora_comeco;
  final int duracao;
  final int chamada_id;
  final int class_id;
  final String status;

  HistoricoInformacaoTurma(
      {required this.class_id,
      required this.status,
      required this.data,
      required this.hora_comeco,
      required this.duracao,
      required this.chamada_id});
}
