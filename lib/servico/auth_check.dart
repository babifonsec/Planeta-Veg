import 'package:flutter/material.dart';
import 'package:planetaveg/servico/auth_service.dart';
import 'package:planetaveg/visao/login.dart';
import 'package:planetaveg/visao/menu.dart';
import 'package:provider/provider.dart';

class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  @override
  Widget build(BuildContext context) {
    AuthService auth = Provider.of(context);

    if(auth.isLoading) return CircularProgressIndicator(
      color: Color(0xFF7A8727),
    );
    else if(auth.usuario==null) return Login();
    else return Menu(0);
  }
}
