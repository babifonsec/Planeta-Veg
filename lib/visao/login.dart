import 'package:flutter/material.dart';
import 'package:planetaveg/servico/auth_service.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final senha = TextEditingController();

  bool isLogin = true;
  late String titulo;
  late String acaoBotao;
  late String textBotao;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setFormAction(true);
  }

  setFormAction(bool acao) {
    setState(() {
      isLogin = acao;
      if (isLogin) {
        titulo = "Bem vindo";
        acaoBotao = "Login";
        textBotao = "Não tem uma conta? Cadastre-se!";
      } else {
        titulo = "Cadastre-se";
        acaoBotao = "Cadastrar";
        textBotao = "Já tem uma conta? Entre!";
      }
    });
  }

  login() async {
    try {
      await context.read<AuthService>().login(email.text, senha.text);
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  registrar() async {
    try {
      await context.read<AuthService>().registrar(email.text, senha.text);
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF672F67),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //LOGO:
              Container(
                child: Image.asset(
                  'assets/logo.png',
                  // width: 250,
                ),
                height: 250,
              ),
              //"CAIXINHA" BRANCA DO LOGIN
              Container(
                width: 330,
                height: 450,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white.withOpacity(0.8),
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 30),
                          child: Text(
                            titulo,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF672F67),
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        //TEXT FIELD DO EMAIL
                        Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: TextFormField(
                            controller: email,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 10),
                              labelText: 'Email: ',
                              labelStyle: TextStyle(
                                color: Color(0xFF7A8727),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFF7A8727),
                                  style: BorderStyle.solid,
                                  width: 5,
                                ),
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Informe o email corretamente";
                              }
                              return null;
                            },
                          ),
                        ),
                        //TEXT FIELD DA SENHA
                        TextFormField(
                          controller: senha,
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 20, horizontal: 10),
                            labelText: 'Senha: ',
                            labelStyle: TextStyle(
                              color: Color(0xFF7A8727),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF7A8727),
                                style: BorderStyle.solid,
                                width: 5,
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Informe sua senha!";
                            } else if (value.length < 6) {
                              return "Sua senha deve ter no mínimo 6 caracteres.";
                            }
                            return null;
                          },
                        ),
                        //BOTAO DE ENTRAR
                        Padding(
                          padding: EdgeInsets.only(top: 20, bottom: 20),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color(0xFF7A8727)),
                              fixedSize: MaterialStateProperty.all<Size>(
                                  Size(150, 50)),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                            ),
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                if (isLogin) {
                                  login();
                                } else{
                                  registrar();
                                }
                              }
                            },
                            child: Row(
                              children: [
                                Icon(Icons.check),
                                Text(
                                  acaoBotao,
                                  style: TextStyle(fontSize: 25),
                                ),
                              ],
                            ),
                          ),
                        ),
                        //REGISTRAR:
                        TextButton(
                          onPressed: () => setFormAction(!isLogin),
                          child: Text(textBotao),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
