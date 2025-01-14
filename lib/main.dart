import 'package:busroutes/Models/bus_routes_model.dart';
import 'package:busroutes/UI/home_page.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
   WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  runApp(const MainApp());
   Hive.registerAdapter(BusRouteAdapter());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}
