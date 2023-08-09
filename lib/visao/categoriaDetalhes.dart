import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:planetaveg/database/dbHelper.dart';
import 'package:planetaveg/modelo/Categoria.dart';

class CategoriaDetalhes extends StatefulWidget {
   CategoriaDetalhes(String this._uid);
   String _uid;

  @override
  State<CategoriaDetalhes> createState() => _CategoriaDetalhesState(_uid);
}

class _CategoriaDetalhesState extends State<CategoriaDetalhes> {
  _CategoriaDetalhesState(String this._uid);
  String _uid;
  FirebaseFirestore db = DBFirestore.get();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
         backgroundColor: Color(0xFF672F67),
         title: FutureBuilder<Categoria?>(
          future: getNome(widget._uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Indicador de carregamento enquanto a Future ainda não está pronta
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              // Trate o erro, se houver
              return Text('Erro: ${snapshot.error}');
            } else {
              // Dados prontos para serem exibidos
              final categoria = snapshot.data;
              if (categoria != null) {
                return Text(categoria.nome);
              } else {
                return Text('Categoria não encontrada');
              }
            }
          },
        ),
    
      ),
    );
  }
}

Future<Categoria?> getNome(String uid) async {
  CollectionReference collection = FirebaseFirestore.instance.collection('categorias');
  
  try {
    QuerySnapshot querySnapshot = await collection.where('UID', isEqualTo: uid).get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
      // Converte o DocumentSnapshot para um mapa e, em seguida, para a instância de Categoria
      return documentSnapshot.get('nome');
    } else {
      // Caso não haja nenhum documento retornado, retorne null ou uma instância vazia de Categoria
      return null;
    }
  } catch (e) {
    print('Erro ao buscar categoria: $e');
    return null;
  }
}

