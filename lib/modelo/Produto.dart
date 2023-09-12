class Produto {
 // late String _id;
  late String _nome;
  late String _descricao;
  late String _ingredientes;
  late String _preco;
  late String _imagem;
  late String _uidLoja;
  late String _uidCategoria;

  Produto(this._nome, this._descricao, this._ingredientes,
      this._preco, this._imagem, this._uidLoja, this._uidCategoria);

  Produto.map(dynamic obj) {
    //this._id = obj['id'];
    this._nome = obj['nome'];
    this._descricao = obj['descricao'];
    this._ingredientes = obj['ingredientes'];
    this._preco = obj['preco'];
    this._imagem = obj['imagem'];
    this._uidLoja = obj['uidLoja'];
    this._uidCategoria = obj['uidCategoria'];
  }

 // String get id => _id;
  String get nome => _nome;
  String get descricao => _descricao;
  String get ingredientes => _ingredientes;
  String get preco => _preco;
  String get imagem => _imagem;
  String get uidLoja => _uidLoja;
  String get uidCategoria => _uidCategoria;

  // Converte o objeto Loja em um mapa que pode ser armazenado no Firestore
  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

   /* if (_id != null) {
      map['id'] = _id;
    }*/
    map['nome'] = _nome;
    map['descricao'] = _descricao;
    map['ingredientes'] = _ingredientes;
    map['preco'] = _preco;
    map['imagem'] = _imagem;
    map['uidLoja'] = _uidLoja;
    map['uidCategoria'] = _uidCategoria;
    return map;
  }

  Produto.fromMap(Map<String, dynamic> map, String id) {
    //this._id = id ?? '';
    this._nome = map['nome'] ?? '';
    this._descricao = map['descricao'] ?? '';
    this._ingredientes = map['ingredientes'] ?? '';
    this._preco = map['preco'] ?? '';
    this._imagem = map['imagem'] ?? '';
    this._uidLoja = map['uidLoja'] ?? '';
    this._uidCategoria = map['uidCategoria'] ?? '';
  }
}
