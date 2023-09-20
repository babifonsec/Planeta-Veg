import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:planetaveg/database/dbHelper.dart';

class Historico extends StatefulWidget {
  const Historico({super.key});

  @override
  State<Historico> createState() => _HistoricoState();
}

class _HistoricoState extends State<Historico> {
  FirebaseFirestore db = DBFirestore.get();
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xFF672F67),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: db
            .collection('pedidos')
            .where('uidCliente', isEqualTo: user!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text('Erro: ${snapshot.error}');
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Text('Nenhum pedido encontrado.');
          }

          // Renderize a lista de pedidos aqui
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final pedido =
                  snapshot.data!.docs[index].data() as Map<String, dynamic>;
              List<dynamic> produtos = pedido['produtos'];

              // Verifique se há produtos antes de acessar
              if (produtos != null && produtos.isNotEmpty) {
                // Suponhamos que você queira exibir o nome do primeiro produto no pedido
                String nomeDoProduto = produtos[0]['nome'];

                return ListTile(
                  title: Text('Pedido: $nomeDoProduto'),
                  // Exiba outras informações do pedido conforme necessário
                );
              } else {
                return ListTile(
                  title: Text('Pedido sem produtos'),
                  // Exiba outras informações do pedido conforme necessário
                );
              }
            },
          );
        },
      ),
    );
  }
}
