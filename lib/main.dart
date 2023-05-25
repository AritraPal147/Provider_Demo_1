import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => BreadCrumbProvider(),
      child: MaterialApp(
        title: 'Flutter Hooks Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: const HomePage(),
        routes: {
          '/new': (context) => const NewBreadCrumbWidget(),
        },
      ),
    ),
  );
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
  UnmodifiableListView<BreadCrumb> get items => UnmodifiableListView(_items);

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

/// select() allows us to track specific parts of a provider
/// instead of the entire provider class
///
/// If the aspect of the provider that is tracked by select()
/// method changes, then, the widget is marked to be rebuilt
/// Ex:
/// context.select((value) => aspect1.value);
///
/// watch() actually allows us to track changes across the
/// entire provider
///
/// Basically, it will react to any change within the provider
/// and mark the widget to be rebuilt
///
///
/// The select() and watch() functions can only be used within
/// build functions. Do not use select and watch functions within
/// void callbacks.
///
///
/// [Consumer] creates a new widget and calls the  builder with its
/// own BuildContext. It also wraps itself around the returned
/// widget from the builder.
///
/// It is useful if the widget returned from the builder depends on
/// the provider before the context itself has access to it.
///
/// [Consumer] has a child widget that does not get rebuilt when
/// the provider changes

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          /// [value] is the provider that we pass to the consumer
          Consumer<BreadCrumbProvider>(
            builder: (BuildContext context, value, Widget? child) {
              return BreadCrumbsWidget(
                breadCrumbs: value.items,
              );
            },
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/new');
            },
            child: const Text(
              'Add new bread crumb',
            ),
          ),
          TextButton(
            onPressed: () {
              /// read() gets current snapshot of provider.
              /// Used for one way communication from callbacks such as onPressed
              context.read<BreadCrumbProvider>().reset();
            },
            child: const Text(
              'Reset',
            ),
          ),
        ],
      ),
    );
  }
}

class NewBreadCrumbWidget extends StatefulWidget {
  const NewBreadCrumbWidget({Key? key}) : super(key: key);

  @override
  State<NewBreadCrumbWidget> createState() => _NewBreadCrumbWidgetState();
}

class _NewBreadCrumbWidgetState extends State<NewBreadCrumbWidget> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new bread crumb'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: 'Enter new bread crumb here...',
            ),
          ),
          TextButton(
            onPressed: () {
              final text = _controller.text;
              /// Checks if TextField is empty or not
              ///
              /// If TextField has data, then a new [BreadCrumb] object is
              /// created and the add() function of the [BreadCrumbProvider]
              /// is called, and then navigation is done to previous screen.
              if (text.isNotEmpty) {
                final breadCrumb =
                    BreadCrumb(isActive: false, name: _controller.text);
                context.read<BreadCrumbProvider>().add(breadCrumb);
                Navigator.of(context).pop();
              }
            },
            child: const Text(
              'Add',
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
