
import 'dart:async';
import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
part 'bus_routes_model.g.dart';

class PaginatedBusRoutes {
  final int total;           // Total number of routes
  final int page;            // Current page number (default: 1)
  final int size;            // Number of routes per page (default: 10)
  final int totalPages;      // Total number of pages available
  final List<BusRoute> routes; // List of routes on the current page

  // Constructor to initialize PaginatedBusRoutes with optional pagination parameters
  PaginatedBusRoutes({
    required this.total,
    this.page = 1,            // Defaults to 1 if not provided
    this.size = 10,           // Defaults to 10 if not provided
    required this.totalPages,
    required this.routes,
  });

  // Factory constructor to create PaginatedBusRoutes from JSON data
  factory PaginatedBusRoutes.fromJson(Map<String, dynamic> json) {
    // Parse the list of routes from JSON data
    var routesList = json['routes'] as List;
    List<BusRoute> routes =
        routesList.map((route) => BusRoute.fromJson(route)).toList();

    return PaginatedBusRoutes(
      total: json['total'],             // Total routes count from JSON
      page: json['page'] ?? 1,          // Default to 1 if page is not specified
      size: json['size'] ?? 10,         // Default to 10 if size is not specified
      totalPages: json['total_pages'],  // Total pages count from JSON
      routes: routes,                   // List of routes as BusRoute objects
    );
  }
}

@HiveType(typeId: 0)
class BusRoute {
    @HiveField(0)
  final String busNumber;
    @HiveField(1)
  final String fromLocation;
    @HiveField(2)
  final String toLocation;
    @HiveField(3)
  final String route;
    @HiveField(4)
  bool isFavourite;
  // Constructor to initialize the BusRoute object with required fields
  BusRoute({
    required this.busNumber,
    required this.fromLocation,
    required this.toLocation,
    required this.route,
    required this.isFavourite
  });

  // Factory constructor to create a BusRoute object from JSON data
   factory BusRoute.fromJson(Map<String, dynamic> json) {
    // Get the current list of favorite routes from Hive
    return BusRoute(
      busNumber: json['bus_number'] as String,
      fromLocation: json['from_location'] as String,
      toLocation: json['to_location'] as String,
      route: json['route'] as String,
      isFavourite: false, // Set based on whether it's in favorites
    );
  }


}

class BusRoutesModel {
  static const String baseurl = 'app-bootcamp.iris.nitk.ac.in';
  static const String path = '/bus_routes/';

 

  Future<PaginatedBusRoutes> fetchPaginatedBusRoutes(String? page) async {
     final Map<String, String?> queryParameters = {
    'page': page ?? '1',
  };
    final uri = Uri.https(baseurl, path, queryParameters);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      return PaginatedBusRoutes.fromJson(json);
    } else {
      throw Exception("Failed to load bus routes");
    }
  }
  Future<List<BusRoute>> fetchSearchedBusRoutes(String? fromLocation, String? toLocation) async {
    final Map<String, String> queryParameters = {};
    if (fromLocation != null) {
      queryParameters['from_location'] = fromLocation;
    }
    if (toLocation != null) {
      queryParameters['to_location'] = toLocation;
    }
    final uri = Uri.https(baseurl, 'bus_routes/search/', queryParameters);    
    // Make the GET request
    final response = await http.get(uri);
      print('$uri');
        // Handle the response
        print(response.statusCode);
    if (response.statusCode == 200) {
      // Parse the response body as a list of maps
      List<dynamic> responseBody = jsonDecode(response.body);

      // Map each list item to a BusRoute object
      List<BusRoute> busRoutes =
          responseBody.map((item) => BusRoute.fromJson(item)).toList();

      return busRoutes;
    } else if (response.statusCode == 404) {
      throw Exception("No matching routes found. [404 Not Found]");
    } else if (response.statusCode == 500) {
      throw Exception("Internal server error. Please try again later. [500]");
    } else {
      throw Exception("Failed to load bus routes: ${response.reasonPhrase} [${response.statusCode}]");
    }
} 
Future<BusRoute> fetchBusbyBusNumber(String busNumber) async {
    final Map<String, String> queryParameters = {};
    final uri = Uri.https(baseurl, 'bus_routes/$busNumber', queryParameters);    
    // Make the GET request
    final response = await http.get(uri);
    print('$uri');
    // Handle the response

    if (response.statusCode == 200) {
      // Parse the response body as a list of maps
        dynamic responseBody = jsonDecode(response.body);

      // Map each list item to a BusRoute object
      BusRoute busRoutes =BusRoute.fromJson(responseBody as Map<String,dynamic>);

      return busRoutes;
    } else if (response.statusCode == 404) {
      throw Exception("No matching routes found. [404 Not Found]");
    } else if (response.statusCode == 500) {
      throw Exception("Internal server error. Please try again later. [500]");
    } else {
      throw Exception("Failed to load bus routes: ${response.reasonPhrase} [${response.statusCode}]");
    }
} 
}