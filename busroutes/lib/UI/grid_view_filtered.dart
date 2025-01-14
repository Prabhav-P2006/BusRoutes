import 'package:busroutes/Models/bus_routes_model.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ProductPageFiltered extends StatelessWidget {
  ProductPageFiltered(
    { required this.routes,
      super.key
      });
  List<BusRoute> routes;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        children: [
          routes.isEmpty ? const Center(child: Text("Nothing to show here")):
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: routes.length,
              itemBuilder: (context, index) {
                final route = routes[index];
                return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "From: ${route.fromLocation}",
                    style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    "To: ${route.toLocation}",
                    style: const TextStyle(fontSize: 14.0, color: Colors.grey),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    "Bus Number: ${route.busNumber}",
                    style: const TextStyle(fontSize: 14.0, color: Colors.blue),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    "Route: ${cleanRoute(route.route)}",
                    style: const TextStyle(fontSize: 14.0, color: Colors.green),
                  ),
                ],
              )
            )
          ],
        ),
      ),
    );
  }
            )
          )
        ]
      )
    );
  }
  String cleanRoute(String route) {
  // RegExp to match printable ASCII characters (letters, digits, punctuation, and spaces)
  final RegExp unprintableChars = RegExp(r'[^\x20-\x7E]+');
  
  // Replace all unprintable characters
  return route.replaceAll(unprintableChars, '-');
}
}