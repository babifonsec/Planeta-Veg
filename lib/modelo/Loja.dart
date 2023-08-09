
class Loja {
  late String _id;
  late String _nome;
  late String _cnpj;
  late String _uidUsuario;
  late String _telefone;

  Loja(this._id, this._nome, this._cnpj, this._uidUsuario, this._telefone);

  Loja.map(dynamic obj) {
    this._id = obj['id'];
    this._nome = obj['nome'];
    this._cnpj = obj['cnpj'];
    this._uidUsuario = obj['uidUsuario'];
    this._telefone = obj['telefone'];
  }

  String get id => _id;
  String get nome => _nome;
  String get cnpj => _cnpj;
  String get uidUsuario => _uidUsuario;
  String get telefone => _telefone;

  // Converte o objeto Loja em um mapa que pode ser armazenado no Firestore
  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    if(_id!=null){
      map['id']=_id;
    }
   map['nome']=_nome;
   map['cnpj']=_cnpj;
   map['uidUsuario']=_uidUsuario;
   map['telefone']=_telefone;
    return map;
  }

    Loja.fromMap(Map<String, dynamic> map, String id) {
    this._id = id ?? '';
    this._nome = map['nome'] ?? '';
    this._cnpj = map['cnpj'] ?? '';
    this._uidUsuario = map['uidUsuario'] ?? '';
     this._telefone = map['telefone'] ?? '';
  }
}
