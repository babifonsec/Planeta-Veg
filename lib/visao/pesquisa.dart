import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:planetaveg/visao/produto/produtoDetalhes.dart';

class Pesquisa extends StatefulWidget {
  const Pesquisa({Key? key});

  @override
  State<Pesquisa> createState() => _PesquisaState();
}

class _PesquisaState extends State<Pesquisa> {
  TextEditingController _pesquisaController = TextEditingController();
  List<QueryDocumentSnapshot> resultado = [];

void _performSearch() async {
  String searchTerm = _pesquisaController.text.trim();
  if (searchTerm.isNotEmpty) {
    try {
      // Converte o termo de pesquisa para ter a primeira letra maiúscula
      String searchTermCapitalized = searchTerm[0].toUpperCase() + searchTerm.substring(1);

      // Executa duas consultas no Firestore para buscar produtos pelo nome
      QuerySnapshot querySnapshotLower = await FirebaseFirestore.instance
          .collection('produtos')
          .orderBy('nome', descending: false)
          .startAt([searchTerm.toLowerCase()]).endAt(
              [searchTerm.toLowerCase() + '\uf8ff']).get();

      QuerySnapshot querySnapshotCapitalized = await FirebaseFirestore.instance
          .collection('produtos')
          .orderBy('nome', descending: false)
          .startAt([searchTermCapitalized]).endAt(
              [searchTermCapitalized + '\uf8ff']).get();

      // Atualiza a lista de resultados
      setState(() {
        resultado = querySnapshotLower.docs + querySnapshotCapitalized.docs;
      });
    } catch (e) {
      print('Erro ao realizar a pesquisa: $e');
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            padding: EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
                color: Color.fromRGBO(216, 216, 216, 0.698),
                borderRadius: BorderRadius.circular(60)),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.search,
                  color: Color(0xFF7A8727),
                ),
                Container(
                  height: 50,
                  width: 250,
                  child: TextField(
                    style: TextStyle(fontSize: 14),
                    controller: _pesquisaController,
                    keyboardType: TextInputType.text,
                    onSubmitted: (_) {
                      _performSearch();
                    },
                    decoration: InputDecoration(
                      labelText: 'Buscar produtos... ',
                      labelStyle: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF7A8727),
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: resultado.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProdutoDetalhes(resultado[index].id),
                    ),
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
                                resultado[index]['imagem'],
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
                                    resultado[index]['nome'],
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
                                  child: Text(resultado[index]['descricao']),
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 150,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Container(
                                        width: 65,
                                        height: 25,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Color.fromARGB(
                                                255, 122, 135, 39)),
                                        child: Center(
                                          child: Text(
                                            'R\$ ${resultado[index]['preco']}',
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
          ),
        ),
      ],
    );
  }
}
