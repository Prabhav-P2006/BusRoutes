// ignore_for_file: unnecessary_import, non_constant_identifier_names

import 'package:busroutes/Models/bus_routes_model.dart';
import 'package:busroutes/UI/favourite_view.dart';
import 'package:busroutes/UI/filter_view.dart';
import 'package:busroutes/UI/grid_view_filtered.dart';
import 'package:busroutes/UI/grid_view_paginated.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

BusRoutesModel busRoutesModel = BusRoutesModel();

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PaginatedBusRoutes paginatedBusRoutes;
  late List<BusRoute> bus_routes;
  late BusRoute bus_route;
  int page_number = 1;
  List<String> locations = ['', ''];
  String busNumber = '';
  bool showingAll = true;
  late Box busRoutesBox;

  @override
  void initState() {
    super.initState();
    Hive.openBox('busRoutesBox').then((box) {
      setState(() {
        busRoutesBox = box;
      });
    });
  }

  Future<PaginatedBusRoutes> fetchPaginatedBusRoutes(String? page) async {
    paginatedBusRoutes = await busRoutesModel.fetchPaginatedBusRoutes(page);
    return await busRoutesModel.fetchPaginatedBusRoutes(page);
  }

  Future<List<BusRoute>> fetchSearchedBus(String fromLocation, String toLocation) async {
    bus_routes = await busRoutesModel.fetchSearchedBusRoutes(
        fromLocation != '' ? fromLocation : null,
        toLocation != '' ? toLocation : null);
    return await busRoutesModel.fetchSearchedBusRoutes(
        fromLocation != '' ? fromLocation : null,
        toLocation != '' ? toLocation : null);
  }

  Future<BusRoute> fetchBusbyBusNumber(String busNumber) async {
    bus_route = await busRoutesModel.fetchBusbyBusNumber(busNumber);
    return await busRoutesModel.fetchBusbyBusNumber(busNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: const Text(
          "Bus Routes",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: IconButton(
              icon: Icon(
                showingAll ? Icons.visibility : Icons.visibility_off,
                color: showingAll ? Colors.white : Colors.red.shade200,
                size: 28,
              ),
              tooltip: 'Toggle View',
              onPressed: () {
                setState(() {
                  showingAll = true;
                  busNumber = '';
                });
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: IconButton(
              icon: const Icon(
                Icons.filter_alt,
                color: Colors.white,
                size: 28,
              ),
              tooltip: 'Filter Routes',
              onPressed: () async {
                final res = await Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const BusFilterMenu()));
                if (res != null && res is List<String>) {
                  setState(() {
                    locations = res;
                    showingAll = false;
                    busNumber = '';
                  });
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.white),
                            SizedBox(width: 8),
                            Text("Filtered successfully"),
                          ],
                        ),
                        duration: const Duration(seconds: 2),
                        backgroundColor: Colors.green.shade600,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    );
                  }
                }
                if (res != null && res is String) {
                  setState(() {
                    busNumber = res;
                    showingAll = false;
                  });
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.white),
                            SizedBox(width: 8),
                            Text("Filtered successfully"),
                          ],
                        ),
                        duration: const Duration(seconds: 2),
                        backgroundColor: Colors.green.shade600,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    );
                  }
                }
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: IconButton(
              icon: const Icon(
                Icons.favorite,
                color: Colors.white,
                size: 28,
              ),
              tooltip: 'Favorites',
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        FavouriteView(busRoutesBox: busRoutesBox)));
              },
            ),
          ),
        ],
        backgroundColor: Colors.green.shade600,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.green.shade50,
              Colors.white,
            ],
          ),
        ),
        child: showingAll
            ? FutureBuilder(
                key: Key(page_number.toString()),
                future: fetchPaginatedBusRoutes(page_number.toString()),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.green.shade600),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.red.shade400,
                            size: 60,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Error: ${snapshot.error}',
                            style: TextStyle(color: Colors.red.shade400),
                          ),
                        ],
                      ),
                    );
                  } else if (snapshot.hasData) {
                    final items = snapshot.data!;
                    return Column(
                      children: [
                        Expanded(
                          child: ProductPagePaginated(
                            paginatedBusRoutes: items,
                            busRoutesBox: busRoutesBox,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, -2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton.icon(
                                icon: const Icon(Icons.arrow_back),
                                label: const Text('Previous'),
                                onPressed: page_number > 1
                                    ? () {
                                        setState(() {
                                          page_number -= 1;
                                        });
                                      }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green.shade600,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                ),
                              ),
                              Text(
                                'Page ${paginatedBusRoutes.page} of ${paginatedBusRoutes.totalPages}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              ElevatedButton.icon(
                                icon: const Icon(Icons.arrow_forward),
                                label: const Text('Next'),
                                onPressed: page_number <
                                        paginatedBusRoutes.totalPages
                                    ? () {
                                        setState(() {
                                          page_number += 1;
                                        });
                                      }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green.shade600,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const Center(child: Text('No data available'));
                  }
                },
              )
            : FutureBuilder(
                future: busNumber != ''
                    ? fetchBusbyBusNumber(busNumber)
                    : fetchSearchedBus(locations[0], locations[1]),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.green.shade600),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.directions_bus,
                              color: Colors.red.shade400,
                              size: 80,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No Matching Routes Found!',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.red.shade400,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Please try adjusting your search criteria.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (snapshot.hasData) {
                    final items = snapshot.data!;
                    if (items is List<BusRoute>) {
                      return ProductPageFiltered(routes: items);
                    } else {
                      final List<BusRoute> temp = [items as BusRoute];
                      return ProductPageFiltered(routes: temp);
                    }
                  } else {
                    return const Center(child: Text('No data available'));
                  }
                },
              ),
      ),
    );
  }
}