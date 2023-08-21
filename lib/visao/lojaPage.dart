import 'package:flutter/material.dart';
import 'package:planetaveg/visao/perfilUsuario.dart';
import 'package:planetaveg/servico/auth_service.dart';
import 'package:provider/provider.dart';

class LojaPage extends StatefulWidget {
  const LojaPage({super.key});

  @override
  State<LojaPage> createState() => _LojaPageState();
}

class _LojaPageState extends State<LojaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF672F67),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            ListTile(
              leading: Icon(
                Icons.person,
                color: Color(0xFF7A8727),
              ),
              title: Text('Sua loja'),
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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              CustomButton(),
              SizedBox(height: 10), // Espaço entre o botão e a linha divisória
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Adicione aqui a lógica para lidar com o clique no botão
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          border: Border.all(color:  Color(0xFF7A8727), width: 2.0),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.add, color:  Color(0xFF7A8727)),
            SizedBox(width: 8.0),
            Text(
              'Novo Produto',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
