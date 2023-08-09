import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:planetaveg/servico/auth_check.dart';
import 'package:planetaveg/servico/auth_service.dart';
import 'package:planetaveg/visao/dadosUsuario.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=> AuthService()),
        ChangeNotifierProvider<Usuario>(
          create: (context) => Usuario(
            auth: context.read<AuthService>(),
          ),
        ),
      ],
      child: MyApp(),),
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
        primarySwatch: Colors.deepPurple,
      ),
      home: AuthCheck(),
    );  
  }
}

