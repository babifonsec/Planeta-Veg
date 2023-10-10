import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:planetaveg/database/dbHelper.dart';
import 'package:planetaveg/visao/endereco/index.dart';
import 'package:planetaveg/visao/carrinho.dart';
import 'package:planetaveg/visao/pedido/historicoPedido.dart';
import 'package:planetaveg/visao/usuario/perfilUsuario.dart';
import 'package:planetaveg/visao/home.dart';
import 'package:planetaveg/servico/auth_service.dart';
import 'package:planetaveg/visao/pesquisa.dart';
import 'package:planetaveg/visao/mapa.dart';
import 'package:provider/provider.dart';

//indice de seleção da tela
int _selectedIndex = 0;
String imageUrl = '';
late final FirebaseAuth _auth;
late final User? user;
FirebaseFirestore db = DBFirestore.get();
DocumentSnapshot? snapshot;

//pegar nome do usuario logado
String getNomeFromSnapshot(DocumentSnapshot? snapshot) {
  if (snapshot != null && snapshot.exists) {
    final data = snapshot.data() as Map<String, dynamic>;
    return data['nome'];
  }
  return '';
}

//vetor de telas a serem utilizadas
List<Widget> _stOptions = <Widget>[
  Home(),
  Pesquisa(),
  Mapa(),
];

//lista de icons
final List<BottomNavigationBarItem> _navegationItens = [
  BottomNavigationBarItem(
    icon: Icon(Icons.home),
    label: 'Início',
  ),
   BottomNavigationBarItem(
    icon: Icon(Icons.search),
    label: 'Buscar',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.map_outlined),
    label: 'Maps',
  ),
 
];

class Menu extends StatefulWidget {
  int _opcao;

  //contrutor passando o indice da tela selecionada
  Menu(this._opcao);

  @override
  _MenuState createState() => _MenuState(this._opcao);
}

class _MenuState extends State<Menu> {
  //construtor
  _MenuState(this._opcao);
  int _opcao;

  @override
  void initState() {
    _selectedIndex = _opcao;

    _auth = FirebaseAuth.instance;
    user = _auth.currentUser;
    db.collection('clientes').doc(user?.uid).get().then(
      (DocumentSnapshot docSnapshot) {
        setState(
          () {
            snapshot = docSnapshot;
            imageUrl = docSnapshot.get('imageUrl');
          },
        );
      },
    );
  }

  Widget build(BuildContext context) {
    final nome = getNomeFromSnapshot(snapshot);

      return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          backgroundColor: Color(0xFF672F67),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Carrinho(),
                  ),
                );
              },
              icon: Icon(
                Icons.shopping_cart,
                color: Colors.white,
              ),
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              SizedBox(
                height: 200,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: Color(0xFF672F67).withOpacity(0.4),
                  ),
                  child: Row(children: [
                    Container(
                      width: 105,
                      height: 105,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.circular(60),
                        color: Color.fromARGB(255, 216, 216, 216),
                      ),
                      child: imageUrl==''
                          ? Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.grey,
                            )
                          : ClipOval(
                              child: FittedBox(
                                fit: BoxFit.cover,
                                child: Image.network(
                                  imageUrl,
                                ),
                              ),
                            ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Usuario(auth: context.read<AuthService>())),
                          );
                        },
                        child: Text(
                          nome,
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Usuario(auth: context.read<AuthService>())),
                        );
                      },
                    ),
                  ]),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.person,
                  color: Color(0xFF7A8727),
                ),
                title: Text('Dados do usuário'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Usuario(auth: context.read<AuthService>())),
                  );
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.house,
                  color: Color(0xFF7A8727),
                ),
                title: Text('Endereços cadastrados'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EnderecosIndex(),
                      ));
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.history,
                  color: Color(0xFF7A8727),
                ),
                title: Text('Histórico de pedidos'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Historico(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.logout,
                  color: Color(0xFF7A8727),
                ),
                title: Text('Sair'),
                onTap: () => context.read<AuthService>().logout(),
              ),
            ],
          ),
        ),
        //corpo da aplicação, aqui são setadas as telas
        body: _stOptions.elementAt(_selectedIndex),
        //botões do BN
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Color(0xFF672F67),
          items: _navegationItens,
          unselectedItemColor: Color(0xFFF5F5F5),
          currentIndex: _selectedIndex,
          selectedItemColor: Color(0xFF7A8727),
          onTap:
              _onItemTapped, //chama o métdodo onItemTapped ao clicar no botao do BTNNavigation
        ),
      );
    
  }

  @override
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
