import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:planetaveg/visao/menu.dart';
import 'package:planetaveg/visao/registrar.dart';
import 'package:planetaveg/visao/splash.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF672F67),
      body: SingleChildScrollView(
        child:
          Center(
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
                  height: 380,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white.withOpacity(0.8),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 30),
                          child: Text(
                            "Login",
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
                          child: TextField(
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 10),
                              labelText: 'Email: ',
                              labelStyle: TextStyle(
                                color: Color(0xFF4C8D26),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFF4C8D26),
                                  style: BorderStyle.solid,
                                  width: 5,
                                ),
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                        ),
                        //TEXT FIELD DA SENHA
                        TextField(
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                            labelText: 'Senha: ',
                            labelStyle: TextStyle(
                              color: Color(0xFF4C8D26),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF4C8D26),
                                style: BorderStyle.solid,
                                width: 5,
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                        //BOTAO DE ENTRAR
                        Padding(
                          padding: EdgeInsets.only(top: 20, bottom: 20),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color(0xFF4C8D26)),
                              fixedSize:
                                  MaterialStateProperty.all<Size>(Size(150, 50)),
                              shape:
                                  MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Splash(1),
                                ),
                              );
                            },
                            child: Text(
                              "Entrar",
                              style: TextStyle(fontSize: 25),
                            ),
                          ),
                        ),
                        //REGISTRAR:
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Não tem uma conta?"),
                            TextButton(
                              onPressed: () {
                                 Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Registrar(),
                                ),
                              );
                              },
                              child: Text(
                                "Registre-se!",
                                style: TextStyle(
                                  color: Color(0xFF672F67),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
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
