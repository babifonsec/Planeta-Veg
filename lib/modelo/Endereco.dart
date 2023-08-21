class Endereco {
  late String _id;
  late String _rua;
  late String _numero;
  late String _bairro;
  late String _complemento;
  late String _cidade;
  late String _cep;

  Endereco(this._rua, this._numero, this._bairro, this._complemento,this._cidade,this._cep);

  Endereco.map(dynamic obj) {
    this._id = obj['id'];
    this._rua = obj['rua'];
    this._numero = obj['numero'];
    this._bairro = obj['bairro'];
    this._complemento = obj['complemento'];
    this._cidade= obj['cidade'];
    this._cep = obj['cep'];
  }

  String get id => _id;
  String get rua => _rua;
  String get numero=> _numero;
  String get bairro => _bairro;
  String get complemento => _complemento;
  String get cidade => _cidade;
  String get cep => _cep;

  // Converte o objeto em um mapa que pode ser armazenado no Firestore
  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    if (_id != null) {
      map['id'] = _id;
    }
    map['rua'] = _rua;
    map['numero'] = _numero;
    map['bairro'] = _bairro;
    map['complemento'] = _complemento;
    map['cidade'] = _cidade;
    map['cep'] = _cep;
    
    return map;
  }

  Endereco.fromMap(Map<String, dynamic> map, String id) {
     this._id = map['id'] ?? '';
    this._rua = map['rua']?? '';
    this._numero = map['numero']??'';
    this._bairro = map['bairro']??'';
    this._complemento = map['complemento']??'';
    this._cidade= map['cidade']??'';
    this._cep = map['cep']??'';
    
  }
}
