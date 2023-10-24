import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:planetaveg/controle/EnderecoController.dart';
import 'package:planetaveg/controle/PedidoController.dart';
import 'package:planetaveg/database/dbHelper.dart';
import 'package:planetaveg/modelo/Endereco.dart';
import 'package:planetaveg/modelo/Pedido.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FinalizarPedido extends StatefulWidget {
  const FinalizarPedido({Key? key}) : super(key: key);

  @override
  State<FinalizarPedido> createState() => _FinalizarPedidoState();
}

class _FinalizarPedidoState extends State<FinalizarPedido> {
  FirebaseFirestore db = DBFirestore.get();
  final User? user = FirebaseAuth.instance.currentUser;
  String? uidEndereco;
  String rua = '';
  double valorTotalCompra = 0.0;
  final key = GlobalKey<FormState>();
  final ruaController = TextEditingController();
  final numeroController = TextEditingController();
  final bairroController = TextEditingController();
  final cidadeController = TextEditingController();
  final complementoController = TextEditingController();
  final cepController = TextEditingController();
  EnderecoController endereco = EnderecoController();

  PedidoController pedidoController = PedidoController();
  List<Map<String, dynamic>> produtos = [];

  // Método para calcular o valor total
  double calcularValorTotal(List<Map<String, dynamic>> produtos) {
    double valorTotal = 0.0;
    for (int i = 0; i < produtos.length; i++) {
      valorTotal = valorTotal + produtos[i]['valorTotal'];
    }
    return valorTotal;
  }

  @override
  void initState() {
    super.initState();
    // Obtem os dados do carrinho e chama o método para calcular o valor total
    db.collection('carrinho').doc(user!.uid).get().then((snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic> carrinhoData =
            snapshot.data() as Map<String, dynamic>;
        List<dynamic> produtosData = carrinhoData['produtos'];

        produtos = List<Map<String, dynamic>>.from(produtosData);
        setState(() {
          valorTotalCompra = calcularValorTotal(produtos);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> enderecoStream = FirebaseFirestore.instance
        .collection('enderecos')
        .where('uidUser', isEqualTo: user!.uid)
        .snapshots();

    DocumentSnapshot enderecoSnapshot;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF672F67),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          'Finalizando pedido',
          style: TextStyle(color: Colors.white),
        ),
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
              onPressed: () {
                // Adicionar o endereço
                if (ruaController.text.isNotEmpty &&
                    numeroController.text.isNotEmpty &&
                    bairroController.text.isNotEmpty &&
                    cidadeController.text.isNotEmpty &&
                    cepController.text.isNotEmpty) {
                  // Adicionar o endereço
                  endereco.adicionarEndereco(
                    Endereco(
                      ruaController.text,
                      numeroController.text,
                      bairroController.text,
                      complementoController.text,
                      cidadeController.text,
                      cepController.text,
                      user!.uid,
                    ),
                  );
                }
                // Fazer uma consulta para obter o uid do novo endereço
                db
                    .collection('enderecos')
                    .where('rua', isEqualTo: ruaController.text)
                    .where('numero', isEqualTo: numeroController.text)
                    .where('bairro', isEqualTo: bairroController.text)
                    .where('complemento', isEqualTo: complementoController.text)
                    .where('cidade', isEqualTo: cidadeController.text)
                    .where('cep', isEqualTo: cepController.text)
                    .where('uidUser', isEqualTo: user!.uid)
                    .get()
                    .then(
                  (QuerySnapshot querySnapshot) {
                    if (querySnapshot.docs.isNotEmpty) {
                      QueryDocumentSnapshot doc = querySnapshot.docs.first;
                      uidEndereco = doc.id;

                      // Continuar com a criação do pedido usando uidEndereco
                      pedidoController.adicionarpedido(
                        Pedido(
                          user!.uid,
                          uidEndereco!,
                          produtos,
                          valorTotalCompra,
                        ),
                        user!.uid,
                      );

                      Navigator.of(context).popUntil((route) => route.isFirst);
                // Exibe um Toast de "Pedido realizado com sucesso"
                Fluttertoast.showToast(
                  msg: "Pedido realizado com sucesso",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Color(0xFF672F67),
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
                    } else {
                    pedidoController.adicionarpedido(
                        Pedido(
                          user!.uid,
                          uidEndereco!,
                          produtos,
                          valorTotalCompra,
                        ),
                        user!.uid,
                      );
                Navigator.of(context).popUntil((route) => route.isFirst);
                // Exibe um Toast de "Pedido realizado com sucesso"
                Fluttertoast.showToast(
                  msg: "Pedido realizado com sucesso",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Color(0xFF672F67),
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
                    }
                  },
                );
                 
              },
              child: Text(
                'Finalizar',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: 10,
              top: 10,
            ),
            child: Text(
              'Qual o endereço de entrega?',
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFF7A8727),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: StreamBuilder<QuerySnapshot>(
              stream: enderecoStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                List<DropdownMenuItem<String>> dropdownItems = [];
                snapshot.data!.docs.forEach((doc) {
                  String endereco = doc['rua'];
                  String uidEndereco = doc.id;

                  dropdownItems.add(
                    DropdownMenuItem<String>(
                      value: uidEndereco,
                      child: Text(endereco),
                    ),
                  );
                });

                if (dropdownItems.isEmpty) {
                  return Form(
                    key: key,
                    child: Column(
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.only(left: 10, bottom: 10, right: 10),
                          child: Container(
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              controller: ruaController,
                              decoration: InputDecoration(
                                labelText: 'Rua',
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 10, bottom: 10),
                              child: Container(
                                width: 200,
                                child: TextFormField(
                                  keyboardType: TextInputType.text,
                                  controller: bairroController,
                                  decoration: InputDecoration(
                                    labelText: 'Bairro',
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 10, bottom: 10, right: 10),
                              child: Container(
                                width: 120,
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: numeroController,
                                  decoration: InputDecoration(
                                    labelText: 'Número',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 10, bottom: 10),
                              child: Container(
                                width: 200,
                                child: TextFormField(
                                  keyboardType: TextInputType.text,
                                  controller: cidadeController,
                                  decoration: InputDecoration(
                                    labelText: 'Cidade',
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 10, bottom: 10, right: 10),
                              child: Container(
                                width: 120,
                                child: TextFormField(
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    CepInputFormatter(),
                                  ],
                                  keyboardType: TextInputType.number,
                                  controller: cepController,
                                  decoration: InputDecoration(
                                    labelText: 'CEP',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(left: 10, bottom: 10, right: 10),
                          child: Container(
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              controller: complementoController,
                              decoration: InputDecoration(
                                labelText: 'Complemento',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return DropdownButtonFormField<String>(
                  value: uidEndereco, // Alterado para a variável local
                  onChanged: (value) {
                    setState(() {
                      uidEndereco = value; // Atualiza a variável local
                    });
                  },
                  items: dropdownItems,
                  hint: Text(rua),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              'Produtos: ',
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFF7A8727),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
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
                                  child: Text(
                                    nome,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),
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
