import 'package:flutter/material.dart';
import 'components/footer.dart';
import 'components/header.dart';
import 'components/networkGrid.dart';
import 'package:es_loader/datas/data.dart';

class HomePage extends StatelessWidget {
  final datas = Datas();

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> gridItems = datas.gridItems;

    return Scaffold(
      backgroundColor: Colors.blueGrey.shade900,
      body: Column(
        children: [
          const header(),
          NetworkGrid(gridItems: gridItems),
          const Footer(),
        ],
      ),
    );
  }
}
