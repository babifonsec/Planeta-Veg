import 'package:flutter/material.dart';
import 'package:planetaveg/visao/categoriaItens.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Home extends StatelessWidget {
  const Home({Key? key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Categorias",
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(0xFF4C8D26),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Container(
                  height: 70,
                  child: categoriaList(),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10, left: 7, right: 7),
                child: ordenar(),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: Text(
                  "Promoções",
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(0xFF4C8D26),
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
                child: Text("Estabelecimentos",
                style: TextStyle(
                    fontSize: 20,
                    color: Color(0xFF4C8D26),
                    fontWeight: FontWeight.bold,
                  ),),
              ),
            ],
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
      CategoriaItem(image: "restaurant.png"),
      CategoriaItem(image: "pizza-slice.png"),
      CategoriaItem(image: "ice-cream.png"),
      CategoriaItem(
        image: "sushi.png",
      ),
      CategoriaItem(image: "wine-bottle.png"),
      CategoriaItem(image: "padaria.png")
    ],
  );
}

Widget ordenar() {
  return Container(
    height: 40,
    padding: EdgeInsets.only(
      left: 20,
    ),
    decoration: BoxDecoration(
      color: Color.fromRGBO(216, 216, 216, 0.698),
      borderRadius: BorderRadius.all(
        Radius.circular(128),
      ),
    ),
    child: Row(
      children: <Widget>[
        Icon(Icons.format_indent_increase_rounded),
        Container(
          width: 200,
          padding: EdgeInsets.only(left: 10),
          child: TextFormField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              border: InputBorder.none,
              labelText: "Ordenar",
              labelStyle: TextStyle(
                color: Color(0xFF4C8D26),
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            style: TextStyle(
              fontSize: 0,
              color: Color(0xFF4C8D26),
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
          height: 100,
          enableInfiniteScroll: true,
          enlargeCenterPage: true,
          autoPlay: true,
        ),
        items: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                child: Image.asset(
                  "assets/salada-grao.jpg",
                  height: 100,
                ),
              ),
              Container(
                height: 100,
                width: 170,
                color: Color(0xFF672F67).withOpacity(0.9),
                child: Column(
                  children: [
                    Text(
                      "Salada de Grão de Bico",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "10% de desconto!",
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF4C8D26),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Text(
                      "Uma porção por apenas 15,00 reais.",
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        //  fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                child: Image.asset(
                  "assets/hamburguer.jpg",
                ),
              ),
              Container(
                height: 100,
                width: 170,
                color: Color(0xFF672F67).withOpacity(0.9),
                child: Column(
                  children: [
                    Text(
                      "Hambúrguer Vegano",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "25% de desconto!",
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF4C8D26),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Text(
                      "2 hambúrgueres por 25,00 reais.",
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        //  fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    ),
  );
}
