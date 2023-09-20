class Carrinho {
  late double valorTotal;
  late List<Map<String, dynamic>> _items;

  Carrinho(this.valorTotal, this._items);

  // Converte o objeto Carrinho em um mapa que pode ser armazenado no Firestore
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'valorTotal': valorTotal,
      'items': _items,
    };
    return map;
  }

  // Construtor para criar um objeto Carrinho a partir de um mapa
  Carrinho.fromMap(Map<String, dynamic> map) {
    valorTotal = map['valorTotal'];
    _items = List<Map<String, dynamic>>.from(map['items']);
  }
}
