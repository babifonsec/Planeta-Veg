import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:planetaveg/database/dbHelper.dart';
import 'package:planetaveg/visao/lojas/lojasDetalhes.dart';

class ListaLojas extends StatefulWidget {
  @override
  State<ListaLojas> createState() => _ListaLojasState();
}

class _ListaLojasState extends State<ListaLojas> {
  FirebaseFirestore db = DBFirestore.get();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        StreamBuilder<QuerySnapshot>(
            stream: db.collection('lojas').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('Erro: ${snapshot.error}'),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text('Nenhuma loja encontrada.'),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot lojasDoc = snapshot.data!.docs[index];
                  final lojasData = lojasDoc.data() as Map<String, dynamic>;

                  return Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                      bottom: 2,
                      top: 5,
                    ),
                    child: Container(
                      width: double.infinity,
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          width: 50,
                          height: 50,
                          child: ClipOval(
                            child: Image.network(
                              lojasData['imagem'],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        title: Text(
                          lojasData['nome'] ?? '',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        onTap: () {
                          final lojaUid = lojasDoc.id;

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  LojasDetalhes(lojaUid: lojaUid),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            })
      ],
    );
  }
}

Stream<QuerySnapshot> getListaLojas() {
  return FirebaseFirestore.instance.collection('lojas').snapshots();
}
