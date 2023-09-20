class Loja {
  late String _id;
  late String _nome;
  late String _cnpj;
  late String _imagem;
  late String _telefone;
  late String _horario;

  Loja(this._id, this._nome, this._cnpj, this._imagem, this._telefone,
      this._horario);

  Loja.map(dynamic obj) {
    this._id = obj['id'];
    this._nome = obj['nome'];
    this._cnpj = obj['cnpj'];
    this._imagem = obj['imagem'];
    this._telefone = obj['telefone'];
    this._horario = obj['horario'];
  }

  String get id => _id;
  String get nome => _nome;
  String get cnpj => _cnpj;
  String get imagem => _imagem;
  String get telefone => _telefone;
  String get horario => _horario;

  // Converte o objeto Loja em um mapa que pode ser armazenado no Firestore
  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    if (_id != null) {
      map['id'] = _id;
    }
    map['nome'] = _nome;
    map['cnpj'] = _cnpj;
    map['imagem'] = _imagem;
    map['telefone'] = _telefone;
    map['horario'] = _horario;
    return map;
  }

  Loja.fromMap(Map<String, dynamic> map, String id) {
    this._id = id ?? '';
    this._nome = map['nome'] ?? '';
    this._cnpj = map['cnpj'] ?? '';
    this._imagem = map['imagem'] ?? '';
    this._telefone = map['telefone'] ?? '';
    this._horario = map['horario'] ?? '';
  }
}
