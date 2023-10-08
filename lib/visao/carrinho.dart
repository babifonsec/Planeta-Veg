import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:planetaveg/database/dbHelper.dart';
import 'package:planetaveg/visao/pedido/pedido.dart';

class Carrinho extends StatefulWidget {
  const Carrinho({super.key});

  @override
  State<Carrinho> createState() => _CarrinhoState();
}

class _CarrinhoState extends State<Carrinho> {
  User? user = FirebaseAuth.instance.currentUser;
  FirebaseFirestore db = DBFirestore.get();
  double valorTotalCompra = 0.0;

// Método para calcular o valor total
  double calcularValorTotal(List<dynamic> produtos) {
    double valorTotal = 0.0;
    for (int i = 0; i < produtos.length; i++) {
      valorTotal = valorTotal + produtos[i]['valorTotal'];
    }
    return valorTotal;
  }

  @override
  void initState() {
    super.initState();
    // Obtem os dados do carrinho e chama o metodo pra calcular o valor total
    db.collection('carrinho').doc(user!.uid).get().then((snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic> carrinhoData =
            snapshot.data() as Map<String, dynamic>;
        List<dynamic> produtos = carrinhoData['produtos'];
        setState(() {
          valorTotalCompra = calcularValorTotal(produtos);
        });
      }
    });
  }

  Future<void> excluirItem(int index) async {
    try {
      // Obtenha o documento do carrinho do usuário atual
      DocumentSnapshot carrinhoSnapshot =
          await db.collection('carrinho').doc(user!.uid).get();

      // Verifique se o carrinho existe e tem produtos
      if (carrinhoSnapshot.exists) {
        Map<String, dynamic> carrinhoData =
            carrinhoSnapshot.data() as Map<String, dynamic>;
        List<dynamic> produtos = List.from(carrinhoData['produtos']);

        // Verifique se o índice é válido
        if (index >= 0 && index < produtos.length) {
          // Remova o produto do carrinho usando o índice
          produtos.removeAt(index);

          // Atualize o carrinho com os produtos restantes
          await db.collection('carrinho').doc(user!.uid).update({
            'produtos': produtos,
          });

          // Atualize o valor total da compra
          setState(() {
            valorTotalCompra = calcularValorTotal(produtos);
          });
        }
      }
    } catch (e) {
      print('Erro ao excluir item do carrinho: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF672F67),
        title: Text(
          'Carrinho',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                minimumSize: Size(220, 55),
                primary: Color(0xFF672F67),
              ),
              onPressed: valorTotalCompra > 0
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FinalizarPedido(),
                        ),
                      );
                    }
                  : null, // Desabilita o botão se valorTotalCompra for igual a 0
              child: Text(
                'Pedir',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          FutureBuilder<DocumentSnapshot>(
            future: db.collection('carrinho').doc(user!.uid).get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Erro: ${snapshot.error}');
              } else if (!snapshot.hasData || !snapshot.data!.exists) {
                return Text('Nenhum produto no carrinho.');
              } else {
                Map<String, dynamic> carrinhoData =
                    snapshot.data!.data() as Map<String, dynamic>;
                List<dynamic> produtos = carrinhoData['produtos'];

                return Expanded(
                  child: ListView.builder(
                    itemCount: produtos.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> produto = produtos[index]['produto'];
                      int quantidade = produtos[index]['qtde'];
                      double preco = double.parse(produto['preco'] ?? '0.0');
                      String nome = produto['nome'] ?? 'Nome não encontrado';
                      String imageUrl =
                          produto['imagem'] ?? 'URL da imagem não encontrada';

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 10,
                              top: 10,
                            ),
                            child: Container(
                              width: 100,
                              height: 90,
                              child: ClipRRect(
                                child: Image.network(
                                  imageUrl,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        nome,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 17,
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.remove_circle_outline,
                                          color: Colors.grey.shade700,
                                        ),
                                        onPressed: () {
                                          excluirItem(index);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 5, right: 15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'R\$ $preco',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      SizedBox(width: 50),
                                      Text('x$quantidade'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      );
                    },
                  ),
                );
              }
            },
          ),
          Center(
            child: Text(
              'Valor total: R\$ $valorTotalCompra',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
