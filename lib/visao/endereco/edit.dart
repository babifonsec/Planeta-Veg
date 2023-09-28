import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:planetaveg/database/dbHelper.dart';
import 'package:planetaveg/modelo/Endereco.dart';
import 'package:planetaveg/controle/EnderecoController.dart';

class EnderecoEdit extends StatefulWidget {
  final String enderecoId;
  EnderecoEdit({required this.enderecoId});

  @override
  State<EnderecoEdit> createState() =>
      _EnderecoEditState(enderecoId: enderecoId);
}

class _EnderecoEditState extends State<EnderecoEdit> {
  String enderecoId;
  _EnderecoEditState({required this.enderecoId});

  FirebaseFirestore db = DBFirestore.get();
  FirebaseStorage storage = FBStorage.get();

  User? user = FirebaseAuth.instance.currentUser;
  final key = GlobalKey<FormState>();
  TextEditingController ruaController = TextEditingController();
  TextEditingController numeroController = TextEditingController();
  TextEditingController bairroController = TextEditingController();
  TextEditingController cidadeController = TextEditingController();
  TextEditingController complementoController = TextEditingController();
  TextEditingController cepController = TextEditingController();
  EnderecoController endereco = EnderecoController();
  @override
  void initState() {
    super.initState();
    loadEnderecoData(); // Carrega os dados do endereco ao abrir a tela
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Atualize seu endereço', style: TextStyle(color: Colors.white),),
    
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xFF672F67),
      ),
      body: SingleChildScrollView(
        child: Form(
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
                        endereco.atualizarEndereco(
                          enderecoId,
                          Endereco(
                              ruaController.text,
                              numeroController.text,
                              bairroController.text,
                              complementoController.text,
                              cidadeController.text,
                              cepController.text,
                              user!.uid),
                        );
                         Fluttertoast.showToast(
                    msg: "Endereço atualizado com sucesso",
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

  //carrega os dados do endereco
  Future<void> loadEnderecoData() async {
    try {
      if (enderecoId != null) {
        DocumentSnapshot snapshot =
            await db.collection('enderecos').doc(enderecoId).get();
        if (snapshot.exists) {
          setState(
            () {
              ruaController.text = snapshot.get('rua');
              numeroController.text = snapshot.get('numero');
              bairroController.text = snapshot.get('bairro');
              cidadeController.text = snapshot.get('cidade');
              complementoController.text = snapshot.get('complemento');
              cidadeController.text = snapshot.get('cidade');
              cepController.text = snapshot.get('cep');
            },
          );
        }
      }
    } catch (e) {
      print('Erro ao carregar dados do Endereço: $e');
    }
  }
}
