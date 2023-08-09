import 'package:flutter/material.dart';
import 'package:planetaveg/visao/categoriaItens.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:planetaveg/visao/listaLojas.dart';

class Home extends StatelessWidget {
  const Home({Key? key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Center(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Categorias",
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFF7A8727),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Container(
                      height: 78,
                      child: categoriaList(),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: Text(
                      "Promoções",
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFF7A8727),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: carousel(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: Text(
                      "Estabelecimentos",
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFF7A8727),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10, left: 7, right: 7),
                    child: ordenar(),
                  ),
                  ListaLojas(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget categoriaList() {
  return ListView(
    scrollDirection: Axis.horizontal,
    children: [
      CategoriaItem(
        image: "assets/restaurant.png",
        uid: 'Ol0WdS1EPwk5q6r4WgZB',
      ),
      CategoriaItem(
        image: "assets/pizza-slice.png",
        uid: 'pUb9i55PhK6XlkClsZGh',
      ),
      CategoriaItem(
        image: "assets/ice-cream.png",
        uid: '0vjavpAIUshzRBzF9Quq',
      ),
      CategoriaItem(
        image: "assets/sushi.png",
        uid: 'EO8uSCQqhLL0kzRTXjxk',
      ),
      CategoriaItem(
        image: "assets/wine-bottle.png",
        uid: 'lylNyPQwdFtAUIhvBNBN',
      ),
      CategoriaItem(
        image: "assets/padaria.png",
        uid: 's46wDrUxYgetgK9aog52',
      ),
      CategoriaItem(
        image: "assets/salad.png",
        uid: '93r2Um43doYYaE1vfS9l',
      ),
      CategoriaItem(
        image: "assets/burger.png",
        uid: 'qP8urmBZm2KvMSFTmpnF',
      ),
      CategoriaItem(
        image: "assets/chocolate.png",
        uid: 'NbuuxNeXQf8HEgnyESdb',
      ),
    ],
  );
}

Widget ordenar() {
  return Container(
    padding: EdgeInsets.only(left: 10),
    decoration: BoxDecoration(
        color: Color.fromRGBO(216, 216, 216, 0.698),
        borderRadius: BorderRadius.circular(60)),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.search),
        Container(
          height: 45,
          width: 250,
          child: TextField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: 'Ordenar ',
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

Widget carousel() {
  return SingleChildScrollView(
    child: Container(
      child: CarouselSlider(
        options: CarouselOptions(
          height: 150,
          enableInfiniteScroll: true,
          enlargeCenterPage: true,
          autoPlay: true,
        ),
        items: [
          Container(
            child: Image.asset(
              "assets/promo-sushi.png",
            ),
          ),
          Container(
            child: Image.asset(
              "assets/promo-wrap.png",
            ),
          ),
        ],
      ),
    ),
  );
}
