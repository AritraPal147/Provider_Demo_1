import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(MaterialApp(
    title: 'Flutter Hooks Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    debugShowCheckedModeBanner: false,
    home: const HomePage(),
  ));
}

/// Class that shows the BreadCrumb
class BreadCrumb {
  /// Variable to check if BreadCrumb is active or not
  bool isActive;

  /// Variable for storing name of BreadCrumb
  final String name;

  /// Unique uuid for each breadcrumb
  final String uuid;

  /// Parameterized constructor for initializing all data
  BreadCrumb({
    required this.isActive,
    required this.name,
  }) : uuid = const Uuid().v4();

  /// Overloading the == operator to compare uuid of 2 breadcrumbs
  @override
  bool operator ==(covariant BreadCrumb other) => uuid == other.uuid;

  /// Overloading the hashCode method to get the hashCode of the uuid
  /// instead of the default hashcode
  @override
  int get hashCode => uuid.hashCode;

}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
    );
  }
}
