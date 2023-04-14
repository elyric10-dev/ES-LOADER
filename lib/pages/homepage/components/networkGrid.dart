import 'package:es_loader/pages/homepage/components/screen/enterPhoneNumber/enterMobileNumberPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NetworkGrid extends StatefulWidget {
  NetworkGrid({
    super.key,
    required List<Map<String, dynamic>> gridItems,
  }) : _gridItems = gridItems;

  final List<Map<String, dynamic>> _gridItems;
  @override
  State<NetworkGrid> createState() => _NetworkGridState();
}

class _NetworkGridState extends State<NetworkGrid> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        itemCount: widget._gridItems.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 1.0,
          mainAxisExtent: 90,
        ),
        itemBuilder: (context, index) {
          final item = widget._gridItems[index];

          // CLICKING NETWORKS
          return GestureDetector(
            onTap: () {
              EnterMobileNumberPage(context, item);
            },
            child: Container(
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.lime, width: 0.8),
                gradient: const LinearGradient(
                  colors: [Colors.white24, Colors.white38],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: AssetImage(item["logo"]),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
