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
  bool orderByAscending = true;
  List<DocumentSnapshot> lojasDocs = [];

  @override
  void initState() {
    super.initState();
    fetchAndSortData();
  }

//busca dados na coleção lojas e chama o sortData
  void fetchAndSortData() async {
    var snapshot = await db.collection('lojas').get();
    lojasDocs = snapshot.docs;

    sortData();
  }

//classifica os documentos com base no nome das lojas: true= ascendente | false=descrescente
  void sortData() {
    setState(() {
      if (orderByAscending) {
        lojasDocs.sort((a, b) => (a.data() as Map<String, dynamic>)['nome']
            .compareTo((b.data() as Map<String, dynamic>)['nome']));
      } else {
        lojasDocs.sort((a, b) => (b.data() as Map<String, dynamic>)['nome']
            .compareTo((a.data() as Map<String, dynamic>)['nome']));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return 
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
    
                return Column(
                  children: [
                    Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: Text(
                  "Estabelecimentos",
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(0xFF7A8727),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              //BOTÃO DE ORDENAR
              IconButton(
                onPressed: () {
                  setState(() {
                    orderByAscending = !orderByAscending;
                    sortData();
                  });
                },
                icon: Icon(Icons.sort_by_alpha_outlined),
              ),
            ],
          ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: lojasDocs.length,
                      itemBuilder: (context, index) {
                        final DocumentSnapshot lojasDoc = lojasDocs[index];
                        final lojasData = lojasDoc.data() as Map<String, dynamic>;
    
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LojasDetalhes(lojaUid: lojasDoc.id), 
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 10,
                              right: 10,
                              bottom: 2,
                              top: 5,
                            ),
                            child: Container(
                              width: double.infinity,
                              child: ListTile(
                                title: Text(lojasData['nome']),
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
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              });
        
  }
}

//PEGA AS LOJAS DO BD
Stream<QuerySnapshot> getListaLojas() {
  return FirebaseFirestore.instance.collection('lojas').snapshots();
}
