import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:planetaveg/database/dbHelper.dart';

class DetalhesPedidoPage extends StatefulWidget {
  final String orderId;
  final List<dynamic> produtos;
  final double valorTotal;
  final String enderecoUid;

  DetalhesPedidoPage({
    required this.orderId,
    required this.produtos,
    required this.valorTotal,
    required this.enderecoUid,
  });

  @override
  _DetalhesPedidoPageState createState() =>
      _DetalhesPedidoPageState(enderecoUid);
}

class _DetalhesPedidoPageState extends State<DetalhesPedidoPage> {
  FirebaseFirestore db = DBFirestore.get();

  final String enderecoUid;

  _DetalhesPedidoPageState(this.enderecoUid);

  Future<Map<String, dynamic>> buscarEndereco() async {
    try {
      DocumentSnapshot enderecoSnapshot =
          await db.collection('enderecos').doc(enderecoUid).get();

      if (enderecoSnapshot.exists) {
        return enderecoSnapshot.data() as Map<String, dynamic>;
      }
    } catch (error) {
      print('Erro ao buscar endereço: $error');
    }
    return {};
  }

  Future<List<Map<String, dynamic>>> buscarProdutos() async {
    try {
      DocumentSnapshot pedidoSnapshot =
          await db.collection('pedidos').doc(widget.orderId).get();

      if (pedidoSnapshot.exists) {
        Map<String, dynamic>? data =
            pedidoSnapshot.data() as Map<String, dynamic>?;

        if (data != null && data.containsKey('produtos')) {
          List<dynamic> produtos = data['produtos'];
          return produtos.map((p) => p as Map<String, dynamic>).toList();
        }
      }
    } catch (error) {
      print('Erro ao buscar produtos: $error');
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detalhes',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xFF672F67),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: buscarEndereco(),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            String rua = snapshot.data!['rua'] ?? '';
            String bairro = snapshot.data!['bairro'] ?? '';
            String numero = snapshot.data!['numero'] ?? '';

            return Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pedido #${widget.orderId}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text('Endereço de entrega: $rua - $numero, $bairro'),
                  SizedBox(height: 5),
                  FutureBuilder<List<Map<String, dynamic>>>(
                    future: buscarProdutos(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        List<Map<String, dynamic>> produtos =
                            snapshot.data ?? [];

                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: produtos.length,
                                itemBuilder: (context, index) {
                                  var produto = produtos[index];
                                  var nome =
                                      produto['produto']['nome'] ?? 'Nome desconhecido';
                                  var preco = produto['produto']['preco'] ?? 0.0;
                                  var quantidade = produto['qtde'] ?? 0;

                                  return ListTile(
                                    title: Text('${nome}'),
                                    subtitle: Text(
                                        'Preço: R\$ ${preco} | Quantidade: ${quantidade}'),
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.none) {
                        return Text("No data");
                      }
                      return CircularProgressIndicator();
                    },
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: Text(
                      'Valor Total: R\$ ${widget.valorTotal}',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.none) {
            return Text("No data");
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
