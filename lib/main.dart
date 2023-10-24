import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:planetaveg/controle/CarrinhoController.dart';
import 'package:planetaveg/controle/EnderecoController.dart';
import 'package:planetaveg/visao/splash.dart';
import 'package:planetaveg/servico/auth_service.dart';
import 'package:planetaveg/visao/usuario/perfilUsuario.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    //provider responsável por fornecer um objeto que pode ser compartilhado em toda 
    //a árvore de widgets do aplicativo 
    MultiProvider(
      providers: [
       ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider<CarrinhoController>(
          create: (context) => CarrinhoController(),
        ),
        ChangeNotifierProvider<EnderecoController>(
          create: (context) => EnderecoController(),
        ),
        ChangeNotifierProvider<Usuario>(
          create: (context) => Usuario(
            auth: context.read<AuthService>(),
          ),
        ),
      ],
      child: MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Planeta Veg',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: Splash(),
    );
  }
}
