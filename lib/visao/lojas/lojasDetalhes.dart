import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:planetaveg/controle/ProdutoController.dart';
import 'package:planetaveg/database/dbHelper.dart';
import 'package:planetaveg/visao/produto/produtoDetalhes.dart';

class LojasDetalhes extends StatefulWidget {
  final String lojaUid;
  LojasDetalhes({required this.lojaUid});

  @override
  State<LojasDetalhes> createState() => _LojasDetalhesState(lojaUid: lojaUid);
}

class _LojasDetalhesState extends State<LojasDetalhes> {
  final String lojaUid;
  _LojasDetalhesState({required this.lojaUid});

  FirebaseFirestore db = DBFirestore.get();
  ProdutoController produto = ProdutoController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF672F67),
            ),
          ),
         
          StreamBuilder<DocumentSnapshot>(
            stream: db.collection('lojas').doc(lojaUid).snapshots(),
            builder: (context, lojaSnapshot) {
              if (lojaSnapshot.hasError) {
                return Center(
                  child: Text('Erro: ${lojaSnapshot.error}'),
                );
              }

              if (lojaSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (!lojaSnapshot.hasData) {
                return const Center(
                  child: Text('Loja não encontrada.'),
                );
              }

              final lojaData =
                  lojaSnapshot.data!.data() as Map<String, dynamic>;
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 110),
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50)),
                      color: Colors.white,
                    ),
                    // height: double.infinity,
                    width: double.infinity,

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                child: ClipOval(
                                  child: Image.network(lojaData['imagem'],
                                      fit: BoxFit.cover),
                                ),
                              ),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    lojaData['nome'] ?? '',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  StreamBuilder<QuerySnapshot>(
                                    stream: db
                                        .collection('enderecos')
                                        .where('uidUser', isEqualTo: lojaUid)
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError) {
                                        return Center(
                                          child:
                                              Text('Erro: ${snapshot.error}'),
                                        );
                                      }

                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }

                                      if (!snapshot.hasData ||
                                          snapshot.data!.docs.isEmpty) {
                                        return const Center(
                                          child: Text(
                                              'Nenhum Endereco encontrado.'),
                                        );
                                      }
                                      // Acessar o primeiro documento no QuerySnapshot
                                      final enderecoDoc =
                                          snapshot.data!.docs[0];

                                      // Acessar os dados do documento
                                      final enderecoData = enderecoDoc.data()
                                          as Map<String, dynamic>;
                                      final rua = enderecoData['rua'];
                                      final numero = enderecoData['numero'];
                                      final bairro = enderecoData['bairro'];
                                      final cidade = enderecoData['cidade'];

                                      return Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('$rua, N°: $numero'),
                                            Text('$bairro - $cidade'),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10,),
                          child: Text(
                            'Produtos: ',
                            style: TextStyle(
                              fontSize: 20,
                              color: Color(0xFF7A8727),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: db
                              .collection('produtos')
                              .where('uidLoja', isEqualTo: lojaUid)
                              .snapshots(), //consulta para retornar apenas os produtos da loja logada
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Center(
                                child: Text('Erro: ${snapshot.error}'),
                              );
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            if (!snapshot.hasData ||
                                snapshot.data!.docs.isEmpty) {
                              return const Center(
                                child: Text('Nenhum produto encontrado.'),
                              );
                            }
                            // Exibe a lista de produtos
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                final DocumentSnapshot productDoc =
                                    snapshot.data!.docs[index];
                                final productData =
                                    productDoc.data() as Map<String, dynamic>;
                                String? produtoId = productDoc.id;

                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Expanded(
                                        child: Row(
                                          children: [
                                            Flexible(
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ProdutoDetalhes(
                                                                produtoId)),
                                                  );
                                                },
                                                child: Container(
                                                  width: 100,
                                                  height: 100,
                                                  child: ClipRect(
                                                    child: Image.network(
                                                        productData['imagem'],
                                                        fit: BoxFit.fill),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 205,
                                              height: 95,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      left: 10,
                                                      bottom: 5,
                                                    ),
                                                    child: InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ProdutoDetalhes(
                                                                      produtoId)),
                                                        );
                                                      },
                                                      child: Text(
                                                        productData['nome'],
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      left: 10,
                                                    ),
                                                    child: Text(productData[
                                                        'descricao']),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Text(
                                              'R\$ ${productData['preco']}',
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                  color: Colors.green.shade700,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Divider(
                                      color: Colors.grey,
                                      thickness: 0.5,
                                      height: 3,
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
           Positioned(
            top: 35.0,
            left: 16.0,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: IconButton(
                color: Color(0xFF672F67),
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
