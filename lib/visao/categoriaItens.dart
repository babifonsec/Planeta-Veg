import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:planetaveg/visao/categoriaDetalhes.dart';

class CategoriaItem extends StatelessWidget {
  final String image;
  final String uid;

  CategoriaItem({required this.image, required this.uid});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          new BoxShadow(
            color: Colors.black12,
            offset: new Offset(1, 1),
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
        borderRadius: BorderRadius.all(
          Radius.circular(200),
        ),
      ),
      child: Expanded(
        child: IconButton(
          icon: Image.asset(
            image,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CategoriaDetalhes(uid)),
            );
          },
        ),
      ),
    );
  }
}
