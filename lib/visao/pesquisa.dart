import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:planetaveg/controle/maps.dart';

class Pesquisa extends StatefulWidget {
  const Pesquisa({super.key});

  @override
  State<Pesquisa> createState() => _PesquisaState();
}

class _PesquisaState extends State<Pesquisa> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PosicaoControle());

    return Container(
      height: double.infinity,
      width: double.infinity,

      child: GetBuilder<PosicaoControle>(
          init: controller,
          builder: (value) => GoogleMap(
                mapType: MapType.normal,
                zoomControlsEnabled: true,
                initialCameraPosition: CameraPosition(
                  target: controller.position,
                  zoom: 16,
                ),
                onMapCreated: controller.onMapCreated,
                myLocationEnabled: true,
              )),
    );
  }
}