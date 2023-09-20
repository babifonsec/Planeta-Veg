import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:planetaveg/modelo/Endereco.dart';

class EnderecoController with ChangeNotifier{
  final CollectionReference _enderecoCollection =
      FirebaseFirestore.instance.collection('enderecos');

  // Adiciona um novo Endereco ao Firestore
  Future<void> adicionarEndereco(Endereco endereco) async {
    try {
      await _enderecoCollection.add(endereco.toMap());
    } catch (e) {
      print('Erro ao adicionar o Endereço: $e');
    }
  }

  // Atualiza os dados de um Endereco no Firestore
  Future<void> atualizarEndereco(String enderecoUid, Endereco endereco) async {
    try {
      final DocumentReference enderecoRef = _enderecoCollection.doc(enderecoUid);

      if (await enderecoRef.get().then((doc) => doc.exists)) {
        await enderecoRef.update(endereco.toMap());
        print('Endereço atualizado com sucesso.');
      } else {
        print('Documento com UID $enderecoUid não encontrado.');
      }
    } catch (e) {
      print('Erro ao atualizar o endereço: $e');
    }
  }

  // Exclui um Endereco do Firestore
  Future<void> excluirEndereco(String enderecoId) async {
    try {
      await _enderecoCollection.doc(enderecoId).delete();
    } catch (e) {
      print('Erro ao excluir o Endereço: $e');
    }
  }

  // Obtém uma lista de todos os Enderecos do Firestore
  Stream<List<Endereco>> getEnderecos() {
    return _enderecoCollection.snapshots().map((snapshot) {
      return snapshot.docs.map(
        (doc) {
          final data = doc.data() as Map<String, dynamic>?;
          if (data != null) {
            return Endereco.fromMap(data, doc.id);
          } else {
            throw Exception(
                'O endereço: ${doc.id} não existe.');
          }
        },
      ).toList();
    });
  }
}