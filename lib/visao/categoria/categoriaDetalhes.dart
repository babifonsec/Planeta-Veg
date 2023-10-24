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
  List<DocumentSnapshot> produtosFiltrados = [];

//pega nome da categoria
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
  }

//caixinha do filtro
  void _mostraDialogFiltro() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Filtrar por:'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _filtroProdutos("OwrMGcTHZkVjZYJKyuZu", uid);
                },
                child: Text(
                  'Vegetariano',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _filtroProdutos("67Lh4MypTb2zAGY1XnJj", uid);
                },
                child: Text(
                  'Vegano',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _filtroTodos(uid);
                },
                child: Text(
                  'Todos',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

//pesquisa filtro:
  void _filtroProdutos(String uidClassificacao, String uidCategoria) {
    db
        .collection('produtos')
        .where('uidClassificacao', isEqualTo: uidClassificacao)
        .where('uidCategoria', isEqualTo: uidCategoria)
        .snapshots()
        .listen(
      (snapshot) {
        setState(
          () {
            produtosFiltrados = snapshot.docs;
          },
        );
      },
    );
  }

//retorna todos produtos
  void _filtroTodos(String uidCategoria) {
    db
        .collection('produtos')
        .where('uidCategoria', isEqualTo: uidCategoria)
        .snapshots()
        .listen(
      (snapshot) {
        setState(
          () {
            produtosFiltrados = snapshot.docs;
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                _mostraDialogFiltro();
              },
              icon: Icon(Icons.filter_alt_rounded))
        ],
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
      body: StreamBuilder<List<DocumentSnapshot>>(
        stream: produtosFiltrados.isNotEmpty
            ? Stream.value(
                produtosFiltrados) // Use Stream.value para criar um Stream a partir da lista
            : db
                .collection('produtos')
                .where('uidCategoria', isEqualTo: uid)
                .snapshots()
                .map((querySnapshot) => querySnapshot
                    .docs), // Mapeie o QuerySnapshot para uma List<DocumentSnapshot>
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

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Nenhum produto encontrado.'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final DocumentSnapshot productDoc = snapshot.data![index];
              final productData = productDoc.data() as Map<String, dynamic>;
              String? produtoId = productDoc.id;

              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProdutoDetalhes(produtoId)),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
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
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                  child: Text(productData['descricao']),
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 135,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Container(
                                        width: 80,
                                        height: 25,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color:
                                              Color.fromARGB(255, 122, 135, 39),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'R\$ ${productData['preco']}',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500),
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
            },
          );
        },
      ),
    );
  }
}
