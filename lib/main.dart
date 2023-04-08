import 'package:flutter/material.dart';
import 'package:flutter_map_app/screens/screens.dart';

void main() => runApp(const MapsApp());

class MapsApp extends StatelessWidget {
  const MapsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MapsApp',
        home: GpsAccessScreen());
  }
}
