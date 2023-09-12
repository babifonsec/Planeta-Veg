import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:planetaveg/controle/ProdutoController.dart';
import 'package:planetaveg/database/dbHelper.dart';

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

                // Exibe a lista de Enderecos
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot categoriaDoc =
                        snapshot.data!.docs[index];
                    final produtoData =
                        categoriaDoc.data() as Map<String, dynamic>;

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
                                produtoData['imagem'],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          title: Text(
                            produtoData['nome'] ?? '',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          subtitle: Text(produtoData['descricao']),
                          onTap: () {},
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
