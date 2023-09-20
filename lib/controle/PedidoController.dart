import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:planetaveg/modelo/Pedido.dart';

class PedidoController with ChangeNotifier {
  final CollectionReference _pedidosCollection =
      FirebaseFirestore.instance.collection('pedidos');

  // Adiciona um novo carrinho ao Firestore
  Future<void> adicionarpedido(Pedido pedido, String uidUser) async {
    try {
      await _pedidosCollection.add(pedido.toMap());
      // Excluir os itens do carrinho do usuário
    await FirebaseFirestore.instance.collection('carrinho').doc(uidUser).delete();
    } catch (e) {
      print('Erro ao adicionar o pedido: $e');
    }
  }

  // Atualiza os dados de um pedido no Firestore
  Future<void> atualizarpedido(String pedidoUid, Pedido pedido) async {
    try {
      final DocumentReference pedidoRef = _pedidosCollection.doc(pedidoUid);

      if (await pedidoRef.get().then((doc) => doc.exists)) {
        await pedidoRef.update(pedido.toMap());
        print('pedido atualizado com sucesso.');
      } else {
        print('Documento com UID $pedidoUid não encontrado.');
      }
    } catch (e) {
      print('Erro ao atualizar o pedido: $e');
    }
  }

  // Exclui um pedido do Firestore
  Future<void> excluirpedido(String pedidoId) async {
    try {
      await _pedidosCollection.doc(pedidoId).delete();
    } catch (e) {
      print('Erro ao excluir o pedido: $e');
    }
  }

  // Obtém uma lista de todos os pedidos do Firestore
 /** Stream<List<pedido>> getpedidos() {
    return _pedidosCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => pedido.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    });
  } */
}
