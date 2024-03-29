import 'dart:io';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:planetaveg/database/dbHelper.dart';
import 'package:planetaveg/modelo/Cliente.dart';
import 'package:planetaveg/servico/auth_service.dart';

class Usuario extends StatefulWidget with ChangeNotifier {
  final AuthService auth;
  Usuario({required this.auth});

  @override
  State<Usuario> createState() => _UsuarioState(auth: auth);
}

class _UsuarioState extends State<Usuario> {
  final key = GlobalKey<FormState>();
  final nomeController = TextEditingController();
  final telefoneController = TextEditingController();
  final cpfController = TextEditingController();

  FirebaseStorage storage = FBStorage.get(); //recupera a instancia do storage
  FirebaseFirestore db = DBFirestore.get(); //recupera a instancia do firestore

  late AuthService auth;
  _UsuarioState({required this.auth});

  bool uploading = false;
  double total = 0;
  String imageUrl = '';
  String clienteImageUrl = '';
  String nome = "Nome";
  String telefone = "Número de telefone";
  String cpf = "CPF";

//pega imagem da galeria do dispositivo
  Future<XFile?> getImage() async {
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    return image;
  }

//faz upload da img no firestore
  Future<UploadTask> upload(String path) async {
    File file = File(path);
    try {
      String ref = 'images/img-${DateTime.now().toString()}.jpg';
      return storage.ref(ref).putFile(file);
    } on FirebaseException catch (e) {
      throw Exception('Erro no upload: ${e.code}');
    }
  }
//chama o getImage e o upload e armazena a url na variavel
  pickAndUpload() async {
    XFile? file = await getImage();
    if (file != null) {
      UploadTask task = await upload(file.path);

      task.snapshotEvents.listen((TaskSnapshot snapshot) async {
        if (snapshot.state == TaskState.running) {
          setState(() {
            uploading = true;
          });
        } else if (snapshot.state == TaskState.success) {
          imageUrl = await snapshot.ref.getDownloadURL();
          setState(() {
            uploading = false;
            clienteImageUrl = imageUrl;
          });
        }
      });
    }
  }

  salvarCliente(Cliente cliente) async {
  DocumentSnapshot snapshot =
      await db.collection('clientes').doc(auth.usuario!.uid).get();
  
  if (snapshot.exists) {
    // Cliente já existe: atualiza os dados existentes
    Map<String, dynamic> dadosExistentes = snapshot.data() as Map<String, dynamic>;

    await db.collection('clientes').doc(auth.usuario!.uid).update({
      'nome': cliente.nome,
      'cpf': cliente.cpf,
      'telefone': cliente.telefone,
      'imageUrl': cliente.imageUrl,
    });
    
    // Mantem o endereço existente
    if (dadosExistentes.containsKey('enderecos')) {
      await db.collection('clientes').doc(auth.usuario!.uid).update({
        'enderecos': dadosExistentes['enderecos'],
      });
    }
  } else {
    // Cliente não existe: cria um novo
    await db.collection('clientes').doc(auth.usuario!.uid).set({
      'nome': cliente.nome,
      'cpf': cliente.cpf,
      'telefone': cliente.telefone,
      'imageUrl': cliente.imageUrl,
  
    });
  }
  setState(() {
    nome = cliente.nome;
    telefone = cliente.telefone;
    cpf = cliente.cpf;
  });
}

//carregar os dados do cliente
  Future<void> loadClienteData() async {
    try {
      User? currentUser = auth.usuario;
      String? userId = currentUser?.uid;

      if (userId != null) {
        DocumentSnapshot snapshot =
            await db.collection('clientes').doc(userId).get();
        if (snapshot.exists) {
          Map<String, dynamic> clienteData =
              snapshot.data() as Map<String, dynamic>;
          setState(() {
            nomeController.text = clienteData['nome'];
            telefoneController.text = clienteData['telefone'];
            cpfController.text = clienteData['cpf'];
            clienteImageUrl = clienteData['imageUrl'];
          });
        }
      }
    } catch (e) {
      print('Erro ao carregar dados do cliente: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    loadClienteData(); // Carrega os dados do cliente ao abrir a tela
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF672F67),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          'Perfil',
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
                child: InkWell(
                  onTap: () => pickAndUpload(),
                  child: Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color.fromARGB(255, 243, 243, 243),
                      border: Border.all(
                        width: 2,
                        color: Color.fromARGB(255, 105, 105, 105),
                      ),
                    ),
                    child: Stack(
                      children: [
                        uploading
                            ? Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  color: Color(0xFF7A8727),
                                ),
                              )
                            : clienteImageUrl.isNotEmpty
                                ? ClipOval(
                                    child: Image.network(
                                      clienteImageUrl,
                                      width: 130,
                                      height: 130,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Center(
                                    child: Icon(
                                      Icons.person,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                  ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: IconButton(
                            icon: Icon(Icons.edit,
                                size: 20,
                                color: Color.fromARGB(255, 105, 105, 105)),
                            onPressed: () {
                              // Aqui você pode adicionar a lógica para a ação de edição
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  child: TextFormField(
                    controller: nomeController,
                    decoration: InputDecoration(
                      labelText: 'Nome',
                      hintText: nome,
                      suffixIcon: Icon(Icons.edit),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  child: TextFormField(
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      TelefoneInputFormatter()
                    ],
                    controller: telefoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Telefone',
                      hintText: telefone,
                      suffixIcon: Icon(Icons.edit),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  child: TextFormField(
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CpfInputFormatter(),
                    ],
                    keyboardType: TextInputType.number,
                    controller: cpfController,
                    //enabled: !cpfController.text.isNotEmpty,
                    decoration: InputDecoration(
                      labelText: 'CPF',
                      hintText: cpf,
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
                        if (GetUtils.isCpf(cpfController.text)) {
                          salvarCliente(Cliente(
                            nomeController.text,
                            cpfController.text,
                            telefoneController.text,
                            clienteImageUrl,
                          ));
                          Fluttertoast.showToast(
                          msg: "Perfil atualizado com sucesso",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Color(0xFF672F67),
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                        }
                        else{
                           Fluttertoast.showToast(
                          msg: "CPF Inválido",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Color(0xFF672F67),
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                        }
                        
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
