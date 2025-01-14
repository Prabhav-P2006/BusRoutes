import 'package:busroutes/Models/bus_routes_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

// ignore: must_be_immutable
class ProductCard extends StatefulWidget {
  final BusRoute busRoute;
  Box? busRoutesBox;
  
  ProductCard({
    super.key,
    required this.busRoute,
    this.busRoutesBox,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  // Constants for styling
  static const double _padding = 16.0;
  static const double _spacing = 8.0;
  static const double _borderRadius = 12.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: _spacing,
        horizontal: 4.0,
      ),
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(_borderRadius),
        onTap: () => _showRouteDetails(context),
        child: Padding(
          padding: const EdgeInsets.all(_padding),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFromToSection(),
                    const SizedBox(height: _spacing),
                    _buildRouteDetails(),
                  ],
                ),
              ),
              _buildFavoriteButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFromToSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.location_on_outlined,
              size: 16,
              color: Colors.grey,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                "From: ${widget.busRoute.fromLocation}",
                style: const TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4.0),
        Row(
          children: [
            const Icon(
              Icons.location_on,
              size: 16,
              color: Colors.grey,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                "To: ${widget.busRoute.toLocation}",
                style: const TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRouteDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.directions_bus_outlined,
              size: 16,
              color: Colors.blue,
            ),
            const SizedBox(width: 4),
            Text(
              "Bus Number: ${widget.busRoute.busNumber}",
              style: const TextStyle(
                fontSize: 14.0,
                color: Colors.blue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4.0),
        Row(
          children: [
            const Icon(
              Icons.route_outlined,
              size: 16,
              color: Colors.green,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                "Route: ${cleanRoute(widget.busRoute.route)}",
                style: const TextStyle(
                  fontSize: 14.0,
                  color: Colors.green,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFavoriteButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(50),
        onTap: () {
          setState(() {
            widget.busRoute.isFavourite = !widget.busRoute.isFavourite;
          });

          // Get the current list of routes
          List<BusRoute> currentRoutes = (widget.busRoutesBox?.get('naya', defaultValue: []).cast<BusRoute>() ?? []);

          if (!widget.busRoute.isFavourite) {
            // Remove this route from favorites
            currentRoutes.removeWhere((route) => route.busNumber == widget.busRoute.busNumber);
          } else {
            if (!currentRoutes.any((route) => route.busNumber == widget.busRoute.busNumber)) {
              currentRoutes.add(widget.busRoute);
            }
          }

          // Save the updated list back to Hive
          widget.busRoutesBox?.put('naya', currentRoutes);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Icon(
              widget.busRoute.isFavourite
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_outlined,
              key: ValueKey(widget.busRoute.isFavourite),
              color: widget.busRoute.isFavourite ? Colors.red : Colors.grey,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }

  void _showRouteDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(_padding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.directions_bus, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  'Bus Route Details',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const Divider(height: 24),
            _buildDetailRow('From Location:', widget.busRoute.fromLocation),
            _buildDetailRow('To Location:', widget.busRoute.toLocation),
            _buildDetailRow('Bus Number:', widget.busRoute.busNumber),
            _buildDetailRow('Route:', cleanRoute(widget.busRoute.route)),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  String cleanRoute(String route) {
    final RegExp unprintableChars = RegExp(r'[^\x20-\x7E]+');
    return route.replaceAll(unprintableChars, '-');
  }
}