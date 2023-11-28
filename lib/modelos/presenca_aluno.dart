class PresencaAluno {
  final int chamada_id;
  final int aluno_id;
  final int class_id;
  final String inicio_chamada;
  final String presenca;


  PresencaAluno(
      {required this.chamada_id,
      required this.aluno_id,
      required this.class_id,
      required this.inicio_chamada,
      required this.presenca,});
}
