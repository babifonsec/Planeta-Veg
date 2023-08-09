import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:planetaveg/database/dbHelper.dart';
import 'package:planetaveg/modelo/Loja.dart';

class ListaLojas extends StatefulWidget {
  const ListaLojas({super.key});

  @override
  State<ListaLojas> createState() => _ListaLojasState();
}

class _ListaLojasState extends State<ListaLojas> {
  List<Loja> items = [];
  FirebaseFirestore db = DBFirestore.get();

  StreamSubscription<QuerySnapshot>? lojasInscricao;

  void initState() {
    super.initState();

    List<Loja> items = [];
    lojasInscricao?.cancel();

    lojasInscricao = db.collection("lojas").snapshots().listen(
      (snapshot) {
        final List<Loja> lojas = snapshot.docs
            .map((documentSnapshot) => Loja.fromMap(
                  documentSnapshot.data(),
                  documentSnapshot.id,
                ))
            .toList();
        setState(
          () => this.items = lojas,
        );
      },
    );
  }

  void dispose() {
    lojasInscricao?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          StreamBuilder(
            stream: getListaLojas(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(
                        color: Color(0xFF7A8727),
                      ),
                    ),
                  );
                default:
                  List<DocumentSnapshot> documentos = snapshot.data!.docs;
                  return Container(
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) => ListTile(
                        title: Text(
                          items[index].nome,
                          style: TextStyle(fontSize: 20),
                        ),
                        leading: Icon(Icons.store),
                      ),
                    ),
                  );
              }
            },
          ),
        ],
      ),
    );
  }
}

Stream<QuerySnapshot> getListaLojas() {
  return FirebaseFirestore.instance.collection('lojas').snapshots();
}
