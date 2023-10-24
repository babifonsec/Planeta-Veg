import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:planetaveg/database/dbHelper.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PromoDetalhes extends StatefulWidget {
String promoId;
   PromoDetalhes(this.promoId);

  @override
  State<PromoDetalhes> createState() => _PromoDetalhesState(promoId);
}

class _PromoDetalhesState extends State<PromoDetalhes> {
String promoId;
_PromoDetalhesState(this.promoId);
 FirebaseFirestore db = DBFirestore.get();
  final key = GlobalKey<FormState>();
  TextEditingController _observacaoController  = TextEditingController();
  int maxCharacters = 140;
  int quantidade = 1;

  User? user = FirebaseAuth.instance.currentUser;

  void aumentarQuantidade() {
    setState(() {
      quantidade++;
    });
  }

  void diminuirQuantidade() {
    if (quantidade > 1) {
      setState(() {
        quantidade--;
      });
    }
  }


//atualiza a tela depois de aumentar ou diminuir a qtde
  @override
  void dispose() {
    _observacaoController .dispose();
    super.dispose();
  }

  Future<void> adicionarProduto(int qtde, String promoId, String observacao) async {
    try {
      DocumentSnapshot promocoesnapshot =
          await db.collection('promocoes').doc(promoId).get();

      if (promocoesnapshot.exists) {
        Map<String, dynamic> produtoData =
            promocoesnapshot.data() as Map<String, dynamic>;

        // Calcula o valor total do produto
        double precoProduto = double.parse(produtoData['preco'] ?? '0.0');
        double valorTotalProduto = precoProduto * qtde;

        // Cria o novo item do carrinho com base nos dados do produto e no valor total
        Map<String, dynamic> novoProdutoNoCarrinho = {
          'qtde': qtde,
          'produto': produtoData,
          'valorTotal': valorTotalProduto,
          'observacao':observacao,
        };

        DocumentReference docRef = db.collection('carrinho').doc(user!.uid);

        //obtem os dados atuais do documento
        DocumentSnapshot docSnapshot = await docRef.get();
        if (docSnapshot.exists) {
          Map<String, dynamic> data =
              docSnapshot.data() as Map<String, dynamic>;

          // Verifica se o campo 'produtos' existe no documento
          if (data.containsKey('produtos')) {
            List<dynamic> produtos = data['produtos'];
            // Adiciona o novo produto ao array de produtos
            produtos.add(novoProdutoNoCarrinho);
            // Atualiza o documento com o novo array de produtos
            await docRef.update({'produtos': produtos});
          } else {
            // Se o campo 'produtos' não existir, cria um novo 
            await docRef.set({
              'produtos': [novoProdutoNoCarrinho]
            }, SetOptions(merge: true));
          }
        } else {
          // Se o documento não existir, cria um novo
          await docRef.set({
            'produtos': [novoProdutoNoCarrinho],

          });
        }
      } else {
        print('Produto com UID $promoId não encontrado.');
      }
    } catch (e) {
      print('Erro ao adicionar produto ao carrinho: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: BottomAppBar(
            shape: CircularNotchedRectangle(),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.grey.shade300,
                    width: 0.5,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            minimumSize: Size(45, 45),
                            primary: Colors.white,
                          ),
                          onPressed: diminuirQuantidade,
                          child: Text(
                            '-',
                            style: TextStyle(
                              color: Color(0xFF672F67),
                              fontSize: 20,
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                        Text(
                          quantidade.toString(),
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(width: 5),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            elevation: 0,
                            minimumSize: Size(45, 45),
                          ),
                          onPressed: aumentarQuantidade,
                          child: Text(
                            '+',
                            style: TextStyle(
                              color: Color(0xFF672F67),
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        minimumSize: Size(220, 50),
                        primary: Color(0xFF672F67),
                      ),
                      onPressed: () {
                        adicionarProduto(quantidade, promoId,_observacaoController.text);

                        Fluttertoast.showToast(
                          msg: "Produto adicionado ao carrinho",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Color(0xFF672F67),
                          textColor: Colors.white,
                          fontSize: 15.0,
                        );
                      },
                      child: Text(
                        'Adicionar',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<DocumentSnapshot>(
          stream: db.collection('promocoes').doc(promoId).snapshots(),
          builder: ((context, snapshot) {
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

            if (!snapshot.hasData) {
              return const Center(
                child: Text('Promoção não encontrada.'),
              );
            }

            final productData = snapshot.data!.data() as Map<String, dynamic>;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(children: [
                  Container(
                    width: double.infinity,
                    height: 230,
                    child: ClipRect(
                      child: Image.network(
                        productData['imagem'],
                        width: double.infinity,
                        height: 270,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 35.0,
                    left: 16.0,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: IconButton(
                        color: Color(0xFF672F67),
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 20, top: 20, bottom: 5),
                              child: Text(
                                productData['nome'],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 24),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 20, bottom: 10),
                              child: Text(
                                productData['descricao'],
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        width: 130,
                        height: 35,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Color.fromARGB(255, 122, 135, 39)),
                        child: Center(
                          child: Text(
                            'R\$ ${productData['preco']}',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: Text(
                              'Ingredientes: ',
                              style: TextStyle(
                                color: Colors.grey.shade800,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 5,
                              top: 3,
                              bottom: 3,
                            ),
                            child: Text(
                              '${productData['ingredientes']}',
                              style: TextStyle(
                                  fontSize: 14, color: Colors.grey.shade700),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, top: 10),
                  child: Row(
                    children: [
                      Icon(
                        Icons.message,
                        color: Colors.grey.shade600,
                        size: 20,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Alguma observação?',
                        style: TextStyle(
                          color: Colors.grey.shade800,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                Form(
                  key: key,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, bottom: 10),
                        child: TextFormField(
                          controller: _observacaoController ,
                          maxLength: maxCharacters,
                          maxLines: null,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Exemplo: sem cebola, sem leite...',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}