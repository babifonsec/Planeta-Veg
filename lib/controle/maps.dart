import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:planetaveg/database/dbHelper.dart';

class PosicaoControle extends GetxController {
  final latitude = 0.0.obs;
  final longitude = 0.0.obs;
  late StreamSubscription<Position> posicaoStream;
  LatLng _position = LatLng(-20.462084, -45.434656);
  late GoogleMapController _mapsController;
  final markers = Set<Marker>();

  static PosicaoControle get to => Get.find<PosicaoControle>();

  get mapsController => _mapsController;
  get position => _position;

  onMapCreated(GoogleMapController gmc) async {
    _mapsController = gmc;
    getPosicao();
    loadLojas();
  }

 loadLojas() async {
    FirebaseFirestore db = DBFirestore.get();
    final lojas = await db.collection('marcadores').get();
    for (var loja in lojas.docs) {
        addMarker(loja);
    }
}


addMarker(QueryDocumentSnapshot loja) async {
  Map<String, dynamic> data = loja.data() as Map<String, dynamic>; // Convertendo os dados para Map<String, dynamic>
  GeoPoint point = data['position']['geopoint'];

  markers.add(
    Marker(
      markerId: MarkerId(loja.id),
      position: LatLng(point.latitude, point.longitude),
      icon: await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(size: Size(5, 5)), 'assets/marker.png'),
      infoWindow: InfoWindow(title: data['nome'], onTap: () => {}),
    ),
  );
  update();
}

  watchPosition() async {
    posicaoStream = Geolocator.getPositionStream().listen((Position position) {
      if (position != null) {
        latitude.value = position.latitude;
        longitude.value = position.longitude;
      }
    });
  }

  @override
  void onClose() {
    posicaoStream.cancel();
    super.onClose();
  }

  Future<Position> _posicaoAtual() async {
    LocationPermission permissao;
    bool ativado = await Geolocator.isLocationServiceEnabled();

    if (!ativado) {
      return Future.error("Por favor, habilite a localização no smartphone");
    }
    permissao = await Geolocator.checkPermission();
    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();

      if (permissao == LocationPermission.denied) {
        return Future.error("Você precisa autorizar o acesso à localização");
      }
    }

    if (permissao == LocationPermission.deniedForever) {
      return Future.error(
          "Você precisa autorizar o acesso à localização nas configurações");
    }

    return await Geolocator.getCurrentPosition();
  }

  getPosicao() async {
    try {
      final posicao = await _posicaoAtual();
      latitude.value = posicao.latitude;
      longitude.value = posicao.longitude;
      _mapsController.animateCamera(
          CameraUpdate.newLatLng(LatLng(latitude.value, longitude.value)));
    } catch (e) {
      Get.snackbar("Erro", e.toString(),
          backgroundColor: Colors.grey[900],
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
    }
  }
} //fim da classe