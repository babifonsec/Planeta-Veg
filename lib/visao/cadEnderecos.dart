import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:planetaveg/database/dbHelper.dart';
import 'package:planetaveg/modelo/Endereco.dart';
import 'package:planetaveg/servico/auth_service.dart';

class CadEndereco extends StatefulWidget with ChangeNotifier {
  AuthService auth;
  CadEndereco({required this.auth});

  @override
  State<CadEndereco> createState() => _CadEnderecoState(auth: auth);
}

class _CadEnderecoState extends State<CadEndereco> {
  final key = GlobalKey<FormState>();
  final bairroController = TextEditingController();
  final cepController = TextEditingController();
  final cidadeController = TextEditingController();
  final complementoController = TextEditingController();
  final numeroController = TextEditingController();
  final ruaController = TextEditingController();

  FirebaseFirestore db = DBFirestore.get(); //recupera a instancia do firestore

  late AuthService auth;
  _CadEnderecoState({required this.auth});

  //double total = 0;
  List<Endereco> items = [];
  String numero = "Número da Casa";
  String rua = "Rua";
  String bairro = "Bairro";
  String cidade = "Cidade";
  String complemento = "Complemento";
  String cep = "CEP";

  Future<void> adicionarEndereco() async {
    try {
      Map<String, dynamic> novoEndereco = {
        'rua': ruaController.text,
        'numero': numeroController.text,
        'bairro': bairroController.text,
        'cidade': cidadeController.text,
        'complemento': complementoController.text,
        'cep': cepController.text,
      };

      DocumentReference docRef =
          db.collection('clientes').doc(auth.usuario!.uid);

      // Primeiro, obtenha os dados atuais do documento
      DocumentSnapshot docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;

        // Verifique se o campo 'enderecos' existe no documento
        if (data.containsKey('enderecos')) {
          List<dynamic> enderecos = data['enderecos'];
          // Adicione o novo endereço ao array de endereços
          enderecos.add(novoEndereco);
          // Atualize o documento com o novo array de endereços
          await docRef.update({'enderecos': enderecos});
        } else {
          // Se o campo 'enderecos' não existir, crie-o com o novo endereço
          await docRef.update({
            'enderecos': [novoEndereco]
          });
        }
      }
    } catch (e) {
      print('Erro ao adicionar endereço: $e');
    }
  }

  StreamSubscription<QuerySnapshot>? enderecosInscricao;


  /*Future<void> loadEnderecoData() async {
    try {
      User? currentUser = auth.usuario;
      String? userId = currentUser?.uid;

      if (userId != null) {
        DocumentSnapshot snapshot =
            await db.collection('enderecos').doc(userId).get();
        if (snapshot.exists) {
          Map<String, dynamic> enderecoData =
              snapshot.data() as Map<String, dynamic>;
        }
      }
    } catch (e) {
      print('Erro ao carregar dados do endereço: $e');
    }
  }*/

 /* @override
  void initState() {
    super.initState();
   // loadEnderecoData(); // Carrega os dados ao abrir a tela

    List<Endereco> items = [];
    enderecosInscricao?.cancel();
    enderecosInscricao = db.collection("enderecos").snapshots().listen(
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
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xFF672F67),
        title: Text(
          'Novo Endereço',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  child: TextFormField(
                    controller: ruaController,
                    decoration: InputDecoration(
                      labelText: 'Rua',
                      hintText: rua,
                      suffixIcon: Icon(Icons.edit),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  child: TextFormField(
                    controller: numeroController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Numero',
                      hintText: numero,
                      suffixIcon: Icon(Icons.edit),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: bairroController,
                    decoration: InputDecoration(
                      labelText: 'Bairro',
                      hintText: bairro,
                      suffixIcon: Icon(Icons.edit),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: complementoController,
                    decoration: InputDecoration(
                      labelText: 'Complemento',
                      hintText: complemento,
                      suffixIcon: Icon(Icons.edit),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: cidadeController,
                    decoration: InputDecoration(
                      labelText: 'Cidade',
                      hintText: cidade,
                      suffixIcon: Icon(Icons.edit),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: cepController,
                    decoration: InputDecoration(
                      labelText: 'CEP',
                      hintText: cep,
                      suffixIcon: Icon(Icons.edit),
                    ),
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    width: 160,
                    child: OutlinedButton(
                      onPressed: () {
                        adicionarEndereco();
                      },
                      child: Text(
                        'Salvar',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Color(0xFF7A8727)),
                        fixedSize:
                            MaterialStateProperty.all<Size>(Size(180, 50)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
