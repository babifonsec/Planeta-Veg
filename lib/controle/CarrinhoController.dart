import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:planetaveg/modelo/Carrinho.dart';

class CarrinhoController with ChangeNotifier {
  final CollectionReference _carrinhosCollection =
      FirebaseFirestore.instance.collection('carrinho');

  // Adiciona um novo carrinho ao Firestore
  Future<void> adicionarCarrinho(Carrinho carrinho) async {
    try {
      await _carrinhosCollection.add(carrinho.toMap());
    } catch (e) {
      print('Erro ao adicionar o carrinho: $e');
    }
  }

  // Atualiza os dados de um carrinho no Firestore
  Future<void> atualizarCarrinho(String carrinhoUid, Carrinho carrinho) async {
    try {
      final DocumentReference carrinhoRef = _carrinhosCollection.doc(carrinhoUid);

      if (await carrinhoRef.get().then((doc) => doc.exists)) {
        await carrinhoRef.update(carrinho.toMap());
        print('Carrinho atualizado com sucesso.');
      } else {
        print('Documento com UID $carrinhoUid não encontrado.');
      }
    } catch (e) {
      print('Erro ao atualizar o carrinho: $e');
    }
  }

  // Exclui um carrinho do Firestore
  Future<void> excluirCarrinho(String carrinhoId) async {
    try {
      await _carrinhosCollection.doc(carrinhoId).delete();
    } catch (e) {
      print('Erro ao excluir o carrinho: $e');
    }
  }

  // Obtém uma lista de todos os carrinhos do Firestore
 /** Stream<List<Carrinho>> getCarrinhos() {
    return _carrinhosCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Carrinho.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    });
  } */
}
