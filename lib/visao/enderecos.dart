import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:planetaveg/database/dbHelper.dart';
import 'package:planetaveg/modelo/Cliente.dart';
import 'package:planetaveg/servico/auth_service.dart';
import 'package:planetaveg/visao/cadEnderecos.dart';
import 'package:provider/provider.dart';
import 'package:planetaveg/modelo/Endereco.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Enderecos extends StatefulWidget {
  AuthService auth;
  Enderecos({required this.auth});

  @override
  State<Enderecos> createState() => _EnderecosState(auth: auth);
}

class _EnderecosState extends State<Enderecos> {
  late AuthService auth;
  _EnderecosState({required this.auth});

  FirebaseFirestore db = DBFirestore.get(); //recupera a instancia do firestore

  List<Endereco> items = [];
  StreamSubscription<QuerySnapshot>? enderecosInscricao;

  @override
  void initState() {
    super.initState();
    List<Cliente> items = [];
    enderecosInscricao?.cancel();
    enderecosInscricao = db.collection("clientes").snapshots().listen(
      (snapshot) {
        final List<Endereco> enderecos = snapshot.docs
            .map((documentSnapshot) => Endereco.fromMap(
                  documentSnapshot.data(),
                  documentSnapshot.id,
                ))
            .toList();
        setState(
          () => this.items = enderecos,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Color(0xFF672F67),
        title: Text(
          "Endereços",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Center(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CadEndereco(auth: context.read<AuthService>())),
                  );
                },
                child: Container(
                  width: 200,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Color(0xFF7A8727)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add,
                        color: Color(0xFF7A8727),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Novo Endereço',
                        style: TextStyle(
                          color: Color(0xFF7A8727),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              'Enderços Cadastrados:',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFF7A8727),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          StreamBuilder(
            stream: getListaEnderecos(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(
                        color: Color(0xFF7A8727),
                      ),
                    ),
                  );
                default:
                  List<DocumentSnapshot> documentos = snapshot.data!.docs;
                  return Container(
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) => Container(
                        //items[index],
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Container(
                            width: 400,
                            height: 175,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color(0xFF7A8727),
                                width: 1.0,
                              ),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  width: 400,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF7A8727),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: 10,
                                        ),
                                        child: Text(
                                          "Rua " + items[index].,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          Text(
                                            'Bairro: ',
                                            style: TextStyle(
                                              color: Color(0xFF7A8727),
                                            ),
                                          ),
                                          Text(
                                            items[index].
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          Text(
                                            'Número: ',
                                            style: TextStyle(
                                              color: Color(0xFF7A8727),
                                            ),
                                          ),
                                          Text(
                                            items[index].numero,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          Text(
                                            'Cidade: ',
                                            style: TextStyle(
                                              color: Color(0xFF7A8727),
                                            ),
                                          ),
                                          Text(
                                            items[index].cidade,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          Text(
                                            'CEP: ',
                                            style: TextStyle(
                                              color: Color(0xFF7A8727),
                                            ),
                                          ),
                                          Text(
                                            items[index].cep,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.all(
                                    10,
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Complemento: ',
                                        style: TextStyle(
                                          color: Color(0xFF7A8727),
                                        ),
                                      ),
                                      Text(
                                        items[index].complemento,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
              }
            },
          ),
        ]),
      ),
    );
  }
}

Stream<QuerySnapshot> getListaEnderecos() {
  return FirebaseFirestore.instance.collection('clientes').snapshots();
}
