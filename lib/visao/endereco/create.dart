
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:planetaveg/database/dbHelper.dart';
import 'package:planetaveg/modelo/Endereco.dart';
import 'package:planetaveg/controle/EnderecoController.dart';
import 'package:planetaveg/servico/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EnderecosCreate extends StatefulWidget {
  final AuthService auth;
  EnderecosCreate({required this.auth});

  @override
  State<EnderecosCreate> createState() => _EnderecosCreateState(auth: auth);
}

class _EnderecosCreateState extends State<EnderecosCreate> {
  AuthService auth;
  _EnderecosCreateState({required this.auth});

  FirebaseFirestore db = DBFirestore.get();
  FirebaseStorage storage = FBStorage.get();
  bool uploading = false;
  User? user = FirebaseAuth.instance.currentUser;
  final key = GlobalKey<FormState>();
  final ruaController = TextEditingController();
  final numeroController = TextEditingController();
  final bairroController = TextEditingController();
  final cidadeController = TextEditingController();
  final complementoController = TextEditingController();
  final cepController = TextEditingController();
  EnderecoController endereco = EnderecoController();
 

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastre seu endereço', style: TextStyle(color: Colors.white),),

        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xFF672F67),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: ruaController,
                    decoration: InputDecoration(
                      labelText: 'Rua',
                      suffixIcon: Icon(Icons.edit),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: numeroController,
                    decoration: InputDecoration(
                      labelText: 'Número',
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
                      suffixIcon: Icon(Icons.edit),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: cepController,
                    decoration: InputDecoration(
                      labelText: 'CEP',
                      suffixIcon: Icon(Icons.edit),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Center(
                  child: Container(
                    width: 160,
                    child: OutlinedButton(
                      onPressed: () {
                        endereco.adicionarEndereco(
                          Endereco(
                              ruaController.text,
                              numeroController.text,
                              bairroController.text,
                              complementoController.text,
                              cidadeController.text,
                              cepController.text,
                              auth.usuario!.uid,),
                        );
                         Fluttertoast.showToast(
                    msg: "Endereço salvo com sucesso",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Color(0xFF672F67),
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
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
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}