import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:planetaveg/visao/pedido/pedidosDetalhes.dart';
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
        title: Text('Histórico de Pedidos', style: TextStyle(color: Colors.white),),
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
        stream: FirebaseFirestore.instance
            .collection('pedidos')
            .where('uidCliente', isEqualTo: user!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text('Erro: ${snapshot.error}');
          }
          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('Você ainda não fez nenhum pedido.'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var pedido = snapshot.data!.docs[index];
              var pedidoData = pedido.data() as Map<String, dynamic>;

              return ListTile(
                title: Text('Pedido #${pedido.id}'),
                subtitle: Text('Total: R\$ ${pedidoData['valorTotal']}'),
                onTap: () {
                   Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DetalhesPedidoPage(
              orderId: pedido.id,
              produtos: pedidoData['produtos'],
              valorTotal: pedidoData['valorTotal'],
              enderecoUid: pedidoData['uidEndereco'],
            ),
          ),
        );
                },
              
              );
            },
          );
        },
      ),
    );
  }
}
