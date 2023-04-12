import 'package:flutter/material.dart';
import 'components/footer.dart';
import 'components/header.dart';
import 'components/networkGrid.dart';

class HomePage extends StatelessWidget {
  final List<Map<String, dynamic>> _gridItems = [
    {
      "logo": "assets/images/smart.png",
      "label": "Smart",
      "color": Colors.green,
    },
    {
      "logo": "assets/images/tnt.png",
      "label": "TNT",
      "color": Colors.deepOrange,
    },
    {
      "logo": "assets/images/sun.png",
      "label": "Sun",
      "color": Colors.yellow,
    },
    {
      "logo": "assets/images/smart_padala.png",
      "label": "Smart Padala",
      "color": Colors.blue.shade900,
    },
    {
      "logo": "assets/images/globe.png",
      "label": "Globe",
      "color": Colors.blue.shade700,
    },
    {
      "logo": "assets/images/tm.png",
      "label": "TM",
      "color": Colors.red,
    },
    {
      "logo": "assets/images/gomo.png",
      "label": "Gomo",
      "color": Colors.pink,
    },
    {
      "logo": "assets/images/gcash.png",
      "label": "Gcash",
      "color": Colors.blue.shade600,
    },
    {
      "logo": "assets/images/dito.png",
      "label": "Dito",
      "color": Colors.red.shade700,
    },
    {
      "logo": "assets/images/cignal.png",
      "label": "Cignal",
      "color": Colors.red,
    },
    {
      "logo": "assets/images/gaming_pins.png",
      "label": "Gaming Pins",
      "color": Colors.black,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade900,
      body: Column(
        children: [
          const header(),
          NetworkGrid(gridItems: _gridItems),
          const Footer(),
        ],
      ),
    );
  }
}
