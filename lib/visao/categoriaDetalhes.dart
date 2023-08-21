import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:planetaveg/database/dbHelper.dart';
import 'package:planetaveg/modelo/Categoria.dart';

class CategoriaDetalhes extends StatefulWidget {
   CategoriaDetalhes(String this.uid);
   String uid;

  @override
  State<CategoriaDetalhes> createState() => _CategoriaDetalhesState(uid);
}

class _CategoriaDetalhesState extends State<CategoriaDetalhes> {
  _CategoriaDetalhesState(String this.uid);
  String uid;
  FirebaseFirestore db = DBFirestore.get();

Future getNome(String uid) async {
  CollectionReference collection = db.collection('categorias');
  
  try {
    DocumentSnapshot  docSnapshot = await collection.doc(uid).get();

    if (docSnapshot.exists) {
      return docSnapshot.get('nome');
    } else {
      return null;
    }
  } catch (e) {
    print('Erro ao buscar categoria: $e');
    return null;
  }

  //print('$uid');
}

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
         iconTheme: IconThemeData(
          color: Colors.white, 
        ),
         backgroundColor: Color(0xFF672F67),
         title: FutureBuilder(
          future: getNome(uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {

              return Text('Erro: ${snapshot.error}');
            } else {
              var categoria = snapshot.data;
              if (categoria != null) {
                return Text(categoria, style: TextStyle(
                  color: Colors.white,
                ),);
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



