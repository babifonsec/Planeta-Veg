import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Perfil extends StatelessWidget {
  const Perfil({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding:
                  EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 130,
                    width: 130,
                    padding: EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        color: Color.fromARGB(255, 146, 146, 146),
                        style: BorderStyle.solid,
                        width: 2,
                      ),
                    ),
                    child: Image.asset(
                      "assets/perfil.png",
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10, top: 20, bottom: 15),
                        child: Text(
                          "Nome do usuário",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          "Bio",
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                padding: EdgeInsets.only(left: 5),
                alignment: Alignment.centerLeft,
                height: 45,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(216, 216, 216, 0.698),
                  borderRadius: BorderRadius.circular(60),
                ),
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    "Endereços cadastrados",
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, bottom: 10, right: 10),
              child: Container(
                padding: EdgeInsets.only(left: 5),
                alignment: Alignment.centerLeft,
                width: MediaQuery.of(context).size.width,
                height: 45,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(216, 216, 216, 0.698),
                  borderRadius: BorderRadius.circular(60),
                ),
                child: TextButton(
                  onPressed: () {},
                  child: Text("Histórico de pedidos"),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, bottom: 10, right: 10),
              child: Container(
                padding: EdgeInsets.only(left: 5),
                alignment: Alignment.centerLeft,
                height: 45,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(216, 216, 216, 0.698),
                  borderRadius: BorderRadius.circular(60),
                ),
                child: TextButton(
                  onPressed: () {},
                  child: Text("Configurações do APP"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
