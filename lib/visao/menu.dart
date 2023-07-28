import 'package:flutter/material.dart';
import 'package:planetaveg/visao/home.dart';
import 'package:planetaveg/servico/auth_service.dart';
import 'package:planetaveg/visao/pesquisa.dart';
import 'package:provider/provider.dart';

//indice de seleção da tela
int _selectedIndex = 0;

//vetor de telas a serem utilizadas
List<Widget> _stOptions = <Widget>[
  Home(),
  Pesquisa(),
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
  }

  Widget build(BuildContext context) {
    if (_selectedIndex == 1) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          //centralizar o campo de pesquisa
          flexibleSpace: Container(
            width: double.infinity,
            alignment: Alignment.bottomCenter,
            child: Container(
              width: 300,
              padding: EdgeInsets.symmetric(vertical: 5),
              child: buscar(),
            ),
          ),
          backgroundColor: Color(0xFF672F67),
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
    } else {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF672F67),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              SizedBox(
                height: 160,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: Color(0xFF672F67),
                  ),
                  child: Container(
                    child: Text(
                      'Bem-vindo user',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                      ),
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.person,
                  color: Color(0xFF7A8727),
                ),
                title: Text('Dados do usuário'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(
                  Icons.history,
                  color: Color(0xFF7A8727),
                ),
                title: Text('Histórico de pedidos'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(
                  Icons.settings,
                  color: Color(0xFF7A8727),
                ),
                title: Text('Configurações'),
                onTap: () {},
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
  }

  @override
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

//retorna a barra de pesquisas no app bar
Widget buscar() {
  return Container(
    padding: EdgeInsets.only(left: 10),
    decoration: BoxDecoration(
        color: Color.fromRGBO(216, 216, 216, 0.698),
        borderRadius: BorderRadius.circular(60)),
    child: Row(
      children: <Widget>[
        Icon(Icons.search),
        Container(
          height: 45,
          width: 250,
          child: TextField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: 'Buscar... ',
              labelStyle: TextStyle(
                fontSize: 15,
                color: Color(0xFF7A8727),
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    ),
  );
}
