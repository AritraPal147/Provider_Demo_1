import 'dart:collection';

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

  /// [activate] function to set [isActive] as true,
  /// basically activate any BreadCrumb object
  void activate() => isActive = true;

  /// Overloading the == operator to compare uuid of 2 breadcrumbs
  @override
  bool operator ==(covariant BreadCrumb other) => uuid == other.uuid;

  /// Overloading the hashCode method to get the hashCode of the uuid
  /// instead of the default hashcode
  @override
  int get hashCode => uuid.hashCode;

  /// Gets [title] as [name] if the BreadCrumb is NOT ACTIVE
  /// Else, gets [title] as [name] + '> '
  String get title => name + (isActive ? '> ' : '');
}

/// Provider for the [BreadCrumb] class
class BreadCrumbProvider extends ChangeNotifier {
  /// List to hold the current BreadCrumb items
  final List<BreadCrumb> _items = [];

  /// [UnmodifiableListView] to display items
  UnmodifiableListView<BreadCrumb> get item => UnmodifiableListView(_items);

  /// Adds a new BreadCrumb to the already existing
  /// list of BreadCrumbs [_items]
  ///
  /// Firstly, it activates all the items that are already in [_items]
  /// Then it add a new BreadCrumb [breadCrumb] into [_items]
  /// Finally, it calls [notifyListeners] to notify all listeners
  /// that are listening to [BreadCrumbProvider]
  void add(BreadCrumb breadCrumb) {
    for (final item in _items) {
      item.activate();
    }
    _items.add(breadCrumb);
    notifyListeners();
  }

  /// Resets the list of BreadCrumbs [_items] and
  /// calls [notifyListeners]
  void reset() {
    _items.clear();
    notifyListeners();
  }
}

/// Widget to display list of [BreadCrumb]s on screen.
class BreadCrumbsWidget extends StatelessWidget {
  final UnmodifiableListView<BreadCrumb> breadCrumbs;

  const BreadCrumbsWidget({
    Key? key,
    required this.breadCrumbs,
  }) : super(key: key);

  /// Color of breadcrumb is blue if breadCrumb is active
  /// else color is black.
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: breadCrumbs.map(
        (breadCrumbs) {
          return Text(
            breadCrumbs.title,
            style: TextStyle(
                color: breadCrumbs.isActive ? Colors.blue : Colors.black),
          );
        },
      ).toList(),
    );
  }
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
