class Cliente {
  late String _id;
  late String _nome;
  late String _cpf;
  late String _telefone;
  late String _imageUrl;

  Cliente(this._nome, this._cpf, this._telefone, this._imageUrl);

  Cliente.map(dynamic obj) {
    this._id = obj['id'];
    this._nome = obj['nome'];
    this._cpf = obj['cpf'];
    this._telefone = obj['telefone'];
    this._imageUrl = obj['imageUrl'];
  }

  String get id => _id;
  String get nome => _nome;
  String get cpf => _cpf;

  String get telefone => _telefone;
  String get imageUrl => _imageUrl;

  // Converte o objeto Loja em um mapa que pode ser armazenado no Firestore
  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    if (_id != null) {
      map['id'] = _id;
    }
    map['nome'] = _nome;
    map['cpf'] = _cpf;
    map['telefone'] = _telefone;
    map['imageUrl'] = _imageUrl;
    return map;
  }

  Cliente.fromMap(Map<String, dynamic> map, String id) {
    this._id = id ?? '';
    this._nome = map['nome'] ?? '';
    this._cpf = map['cpf'] ?? '';
    this._telefone = map['telefone'] ?? '';
    this._imageUrl = map['imageUrl'] ?? '';
  }
}
