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
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 400,
              color: Colors.white, 
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
                  child: Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50)),
                        color: Colors.white,
                      ),
                   //  height: double.infinity,
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
                                Center(
                                  child: Column(
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
                                ),
                  
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Horário de Atendimento: ${lojaData['horario']}'),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 10,
                            ),
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
                                      final productData = productDoc.data()
                                          as Map<String, dynamic>;
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
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Row(
                                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Container(
                                                    height: 100,
                                                    width: 120,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
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
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 8,
                                                                  bottom: 8,
                                                                  right: 8),
                                                          child: Text(
                                                            productData['nome'],
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 8,
                                                                  bottom: 10),
                                                          child: Text(productData[
                                                              'descricao']),
                                                        ),
                                                        Row(
                                                          children: [
                                                            SizedBox(
                                                              width: 130,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 5),
                                                              child: Container(
                                                                width: 80,
                                                                height: 25,
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                20),
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            122,
                                                                            135,
                                                                            39)),
                                                                child: Center(
                                                                  child: Text(
                                                                    'R\$ ${productData['preco']}',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            13,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500),
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
                                    });
                              })
                        ],
                      ),
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
