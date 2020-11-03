class FollowPiece {
  String key;
  String nome;
  String pieceId;
  String carId;
  bool precisaManutencao;
  DateTime ultimaManutencao;

  FollowPiece(
      {this.nome,
      this.pieceId,
      this.carId,
      this.precisaManutencao = false,
      this.ultimaManutencao});

  FollowPiece copyWith(
      {String nome,
      String pieceId,
      String carId,
      bool precisaManutencao,
      DateTime ultimaManutencao}) {
    return new FollowPiece(
        nome: nome ?? this.nome,
        pieceId: pieceId ?? this.pieceId,
        carId: carId ?? this.carId,
        ultimaManutencao: ultimaManutencao ?? this.ultimaManutencao,
        precisaManutencao: precisaManutencao ?? this.precisaManutencao);
  }

  toJson() {
    return {
      "nome": nome,
      "pieceId": pieceId,
      "carId": carId,
      "precisaManutencao": precisaManutencao,
      "ultimaManutencao": ultimaManutencao
    };
  }
}
