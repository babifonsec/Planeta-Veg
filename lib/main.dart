import 'package:flutter/material.dart';
import 'package:planetaveg/visao/splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override 
  Widget build(BuildContext context) {  
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Planeta Veg',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Splash(0),
    );  
  }
}