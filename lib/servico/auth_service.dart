import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//classe para tratar exceções ao entrar/registrar no app
class AuthException implements Exception{
  String message;
  AuthException({required this.message});
}


//autenticacao
class AuthService extends ChangeNotifier{
  FirebaseAuth _auth = FirebaseAuth.instance;
  User? usuario;
  bool isLoading = true;

  AuthService(){
    _authCheck();
  }
  
  //usa authStateChanges() para ouvir as alterações no estado de autenticação do Firebase
_authCheck(){
  _auth.authStateChanges().listen((User? user) {
  usuario = (user==null) ? null : user;
  isLoading=false;
  notifyListeners();
   });
}


_getUser(){
  usuario = _auth.currentUser;
  notifyListeners();
}

registrar(String email, String senha) async {

try{
  await _auth.createUserWithEmailAndPassword(email: email, password: senha);
  _getUser();
}on FirebaseAuthException catch(e){
if(e.code=='weak-password'){
  throw AuthException(message: 'A senha é muito farca!');
} else if (e.code =='email-already-in-use'){
  throw AuthException(message: 'Este email já está em uso!');
}
}
}


login(String email, String senha) async {

try{
  await _auth.signInWithEmailAndPassword(email: email, password: senha);
  _getUser();
}on FirebaseAuthException catch(e){
if(e.code=='user-not-found'){
  throw AuthException(message:'Email não encontrado.');
} else if (e.code =='wrong-password'){
  throw AuthException(message: 'Senha Incorreta. Tente novamente!');
}
}
}

logout() async{
  await _auth.signOut();
  _getUser();
}
}