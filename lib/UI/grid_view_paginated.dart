import 'package:busroutes/Models/bus_routes_model.dart';
import 'package:busroutes/UI/product_card.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

// ignore: must_be_immutable
class ProductPagePaginated extends StatelessWidget {
  ProductPagePaginated({
    required this.paginatedBusRoutes,
    required this.busRoutesBox,
    super.key,
  });

  final PaginatedBusRoutes paginatedBusRoutes;
       Box busRoutesBox;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: paginatedBusRoutes.routes.length,
              itemBuilder: (context, index) {
                final route = paginatedBusRoutes.routes[index];
                return ProductCard(
                  busRoute: route,
                  busRoutesBox: busRoutesBox,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

