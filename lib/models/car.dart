class Car {
  String key;
  String nome;
  String marca;
  String modelo;
  bool maisUsado;

  Car({this.nome, this.marca, this.modelo, this.maisUsado});

  Car copyWith({String nome, String marca, String modelo, bool maisUsado}) {
    return new Car(
        nome: nome ?? this.nome,
        marca: marca ?? this.marca,
        modelo: modelo ?? this.modelo,
        maisUsado: maisUsado ?? this.maisUsado);
  }

  toJson() {
    return {
      "nome": nome,
      "marca": marca,
      "modelo": modelo,
      "maisUsado": maisUsado
    };
  }
}
