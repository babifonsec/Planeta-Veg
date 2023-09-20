import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:planetaveg/controle/ProdutoController.dart';
import 'package:planetaveg/database/dbHelper.dart';
import 'package:planetaveg/visao/produto/produtoDetalhes.dart';

class CategoriaDetalhes extends StatefulWidget {
  CategoriaDetalhes(String this.uid);
  final String uid;

  @override
  State<CategoriaDetalhes> createState() => _CategoriaDetalhesState(uid);
}

class _CategoriaDetalhesState extends State<CategoriaDetalhes> {
  _CategoriaDetalhesState(String this.uid);
  String uid;
  FirebaseFirestore db = DBFirestore.get();
  ProdutoController produto = ProdutoController();

  Future getNome(String uid) async {
    CollectionReference collection = db.collection('categorias');

    try {
      DocumentSnapshot docSnapshot = await collection.doc(uid).get();

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
    return Scaffold(
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
                return Text(
                  categoria,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                );
              } else {
                return Text('Categoria não encontrada');
              }
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: db
                  .collection('produtos')
                  .where('uidCategoria', isEqualTo: uid)
                  .snapshots(), //consulta para retornar apenas os Enderecos da loja logada
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
                    child: Text('Nenhum produto encontrado.'),
                  );
                }

                return SingleChildScrollView(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final DocumentSnapshot productDoc =
                            snapshot.data!.docs[index];
                        final productData =
                            productDoc.data() as Map<String, dynamic>;
                        String? produtoId = productDoc.id;

                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ProdutoDetalhes(produtoId)),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 10, left: 10, right: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      height: 100,
                                      width: 120,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          productData['imagem'],
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8, bottom: 8, right: 8),
                                            child: Text(
                                              productData['nome'],
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8, bottom: 10),
                                            child:
                                                Text(productData['descricao']),
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: 150,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5),
                                                child: Container(
                                                  width: 65,
                                                  height: 25,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      color: Color.fromARGB(
                                                          255, 122, 135, 39)),
                                                  child: Center(
                                                    child: Text(
                                                      'R\$ ${productData['preco']}',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
