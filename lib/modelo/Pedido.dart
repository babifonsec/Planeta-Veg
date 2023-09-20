class Pedido {
  late String _uidCliente;
  late String _uidEndereco;
  late List<Map<String, dynamic>> _produtos;
  late double _valorTotal;

  Pedido(this._uidCliente, this._uidEndereco, this._produtos,
      this._valorTotal);

  Pedido.map(dynamic obj) {

    this._uidCliente = obj['uidCliente'];
    this._uidEndereco = obj['uidEndereco'];
    this._produtos = obj['produtos'];
    this._valorTotal = obj['valorTotal'];
  }


  String get uidCliente => _uidCliente;
  String get uidEndereco => _uidEndereco;
  List get produtos => _produtos;
  double get valorTotal => _valorTotal;

  // Converte o objeto Loja em um mapa que pode ser armazenado no Firestore
  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map['uidCliente'] = _uidCliente;
    map['uidEndereco'] = _uidEndereco;
    map['produtos'] = _produtos;
    map['valorTotal'] = _valorTotal;

    return map;
  }

  Pedido.fromMap(Map<String, dynamic> map, String uidLoja) {
    this._uidCliente = map['uidCliente'] ?? '';
    this._uidEndereco = map['uidEndereco'] ?? '';
    this._produtos = map['produtos'] ?? '';
    this._valorTotal = map['valorTotal'] ?? '';
  }
}
