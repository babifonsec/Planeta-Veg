import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:planetaveg/controle/EnderecoController.dart';
import 'package:planetaveg/database/dbHelper.dart';
import 'package:planetaveg/servico/auth_service.dart';
import 'package:planetaveg/visao/endereco/create.dart';
import 'package:planetaveg/visao/endereco/edit.dart';
import 'package:provider/provider.dart';
//import 'package:planetaveg/visao/endereco/edit.dart';

class EnderecosIndex extends StatefulWidget {
  const EnderecosIndex({super.key});

  @override
  State<EnderecosIndex> createState() => _EnderecosIndexState();
}

class _EnderecosIndexState extends State<EnderecosIndex> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore db = DBFirestore.get();
  EnderecoController Endereco = EnderecoController();

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF672F67),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => EnderecosCreate(
                auth: context.read<AuthService>(),
              ),
            ),
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'Endereços Cadastrados:',
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF7A8727),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: db
                  .collection('enderecos')
                  .where('uidUser', isEqualTo: user?.uid)
                  .snapshots(), //consulta para retornar apenas os Enderecos da loja logada
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Erro: ${snapshot.error}'),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('Nenhum Endereco encontrado.'),
                  );
                }

                // Exibe a lista de Enderecos
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot enderecoDoc =
                        snapshot.data!.docs[index];
                    final enderecoData =
                        enderecoDoc.data() as Map<String, dynamic>;
                    String? enderecoId = enderecoDoc.id;

                    return Padding(
                      padding: const EdgeInsets.only(
                          left: 5, right: 10, bottom: 5, top: 5),
                      child: Container(
                        height: 60,
                        child: ListTile(
                          leading: const Icon(
                            Icons.home,
                            color: Color(0xFF7A8727),
                          ),
                          title: Text(enderecoData['rua'] ?? ''),
                          subtitle: Text(enderecoData['bairro'] ?? ''),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.grey),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EnderecoEdit(enderecoId: enderecoId),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.grey),
                                onPressed: () {
                                  String? enderecoUid = enderecoDoc.id;
                                  if (enderecoUid != null) {
                                    context
                                        .read<EnderecoController>()
                                        .excluirEndereco(enderecoUid);
                                  } else {
                                    throw Exception(
                                        'UID do Endereco ausente ou nulo.');
                                  }

                                  Fluttertoast.showToast(
                                    msg: "Endereço removido com sucesso",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Color(0xFF672F67),
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
