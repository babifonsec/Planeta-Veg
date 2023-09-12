import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:planetaveg/modelo/Produto.dart';

class ProdutoController with ChangeNotifier {
  final CollectionReference _produtosCollection =
      FirebaseFirestore.instance.collection('produtos');

  // Adiciona um novo produto ao Firestore
  Future<void> adicionarProduto(Produto produto) async {
    try {
      await _produtosCollection.add(produto.toMap());
    } catch (e) {
      print('Erro ao adicionar o produto: $e');
    }
  }

  // Atualiza os dados de um produto no Firestore
  Future<void> atualizarProduto(String produtoUid, Produto produto) async {
    try {
      final DocumentReference produtoRef = _produtosCollection.doc(produtoUid);

      if (await produtoRef.get().then((doc) => doc.exists)) {
        await produtoRef.update(produto.toMap());
        print('Produto atualizado com sucesso.');
      } else {
        print('Documento com UID $produtoUid não encontrado.');
      }
    } catch (e) {
      print('Erro ao atualizar o produto: $e');
    }
  }

  // Exclui um produto do Firestore
  Future<void> excluirProduto(String produtoId) async {
    try {
      await _produtosCollection.doc(produtoId).delete();
    } catch (e) {
      print('Erro ao excluir o produto: $e');
    }
  }

  // Obtém uma lista de todos os produtos do Firestore
  /**Stream<List<Produto>> getProdutos() {
    return _produtosCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Produto.fromMap(doc.data(), doc.id))
          .toList();
    });
  }**/
}
