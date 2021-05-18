import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'backdrop.dart';
import 'category.dart';
import 'category_tile.dart';
import 'unit.dart';
import 'unit_converter.dart';

// Category Route (Screen)

// This is the 'home' screen of the Unit Converter. It shows a header and a list of [Categories].
// While it is named CategoryRoute, a more apt name would be CategoryScreen,
// because it is responsible for the UI at the route's destination.

class CategoryRoute extends StatefulWidget {
  const CategoryRoute();

  @override
  _CategoryRouteState createState() => _CategoryRouteState();
}

class _CategoryRouteState extends State<CategoryRoute> {
  // Widget are supposed to be deeply immutable objects. We can update and edit
  // _categories as we build our app, and when we pass it into a widget's 'children' property, we call .toList() on it.
  //
  Category _defaultCategory;
  Category _currentCategory;
  // [Category]
  final _categories = <Category>[];
  // Remove _categoryNames as they will be retrieved from the JSON asset
  // static const _categoryNames = <String>[
  //   'length',
  //   'Area',
  //   'Volume',
  //   'Mass',
  //   'Time',
  //   'Digital Storage',
  //   'Energy',
  //   'Currency',
  // ];

  static const _baseColors = <ColorSwatch>[
    ColorSwatch(0xFF6AB7A8, {
      'highlight': Color(0xFF6AB7A8),
      'splash': Color(0xFF0ABC9B),
    }),
    ColorSwatch(0xFFFFD28E, {
      'highlight': Color(0xFFFFD28E),
      'splash': Color(0xFFFFA41C),
    }),
    ColorSwatch(0xFFFFB7DE, {
      'highlight': Color(0xFFFFB7DE),
      'splash': Color(0xFFF94CBF),
    }),
    ColorSwatch(0xFF8899A8, {
      'highlight': Color(0xFF8899A8),
      'splash': Color(0xFFA9CAE8),
    }),
    ColorSwatch(0xFFEAD37E, {
      'highlight': Color(0xFFEAD37E),
      'splash': Color(0xFFFFE070),
    }),
    ColorSwatch(0xFF81A56F, {
      'highlight': Color(0xFF81A56F),
      'splash': Color(0xFF7CC159),
    }),
    ColorSwatch(0xFFD7C0E2, {
      'highlight': Color(0xFFD7C0E2),
      'splash': Color(0xFFCA90E5),
    }),
    ColorSwatch(0xFFCE9A9A, {
      'highlight': Color(0xFFCE9A9A),
      'splash': Color(0xFFF94D56),
      'error': Color(0xFF912D2D),
    }),
  ];

  // TODO: Add image asset paths in here.

// Remove the overriding of initState(). Instead, we use didChangeDependecies()
  // @override
  // void initState() {
  //   super.initState();
  //   // Set the default [Category] for the unit converter that opens
  //   for (var i = 0; i < _categoryNames.length; i++) {
  //     var category = Category(
  //       name: _categoryNames[i],
  //       color: _baseColors[i],
  //       iconLocation: Icons.cake,
  //       units: _retrieveUnitList(_categoryNames[i]),
  //     );
  //     if (i == 0) {
  //       _defaultCategory = category;
  //     }
  //     _categories.add(category);
  //   }
  // }

  /// We use didChangeDependencies() so that we can wait for our JSON asset to be loaded in (async).
  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    // We have static unit conversions located in our assets/data/reguler_units.json
    if (_categories.isEmpty) {
      await _retrieveLocalCategories();
    }
  }

  /// Retrieve a list of [Categories] and their [Unit]s
  Future<void> _retrieveLocalCategories() async {
    // Consider omitting the types for local variables.
    final json = DefaultAssetBundle.of(context)
        .loadString('assets/data/regular_units.json');

    final data = JsonDecoder().convert(await json);
    if (data is! Map) {
      throw ('Data retrieved from API is not a Map');
    }
    //
    /// Create Categories and their list of Units, from the JSON assets
    var categoryIndex = 0;
    data.keys.forEach((key) {
      final List<Unit> units =
          data[key].map<Unit>((dynamic data) => Unit.fromJson(data)).toList();

      var category = Category(
        name: key,
        units: units,
        color: _baseColors[categoryIndex],
        // TODO: Replace the placeholder icon with an icon iamge path
        iconLocation: Icons.cake,
      );
      setState(() {
        if (categoryIndex == 0) {
          _defaultCategory = category;
        }
        _categories.add(category);
      });
      categoryIndex += 1;
    });
  }

  /// This function to call when a [Category] is tapped.
  void _onCategoryTap(Category category) {
    setState(() {
      _currentCategory = category;
    });
  }

  /// Makes that the correct number of rows for the list view, based on wheter the device is portrait or landscape.
  //
  /// For Portrait, that we use a [ListView]. For the landscape we use a [GridView].
  Widget _buildCategoryWidgets(Orientation deviceOrientation) {
    if (deviceOrientation == Orientation.portrait) {
      return ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return CategoryTile(
            category: _categories[index],
            onTap: _onCategoryTap,
          );
        },
        itemCount: _categories.length,
      );
    } else {
      return GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 3.0,
        // Assign it into the list with .toList() in the bottom
        children: _categories.map((Category c) {
          return CategoryTile(
            category: c,
            onTap: _onCategoryTap,
          );
        }).toList(),
      );
    }
  }

  // Delete this function; instead, read in the units from the JSON assets inside _retrieveLocalCategories()
  /// Returns a list of mock [Unit]s.
  // List<Unit> _retrieveUnitList(String categoryName) {
  //   // when the app first starts up
  //   return List.generate(10, (int i) {
  //     i += 1;
  //     return Unit(
  //       name: '$categoryName Unit $i',
  //       conversion: i.toDouble(),
  //     );
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    if (_categories.isEmpty) {
      return Center(
        child: Container(
          height: 180.0,
          width: 180.0,
          child: CircularProgressIndicator(),
        ),
      );
    }
    // Based on the device size, figure out how to best layout the list
    // So you can also use MediaQuery.of(context).size to calcualte the orientation.
    assert(debugCheckHasMediaQuery(context));
    final listView = Padding(
      padding: EdgeInsets.only(
        left: 8.0,
        right: 8.0,
        bottom: 48.0,
      ),
      child: _buildCategoryWidgets(MediaQuery.of(context).orientation),
    );
    return Backdrop(
      currentCategory:
          _currentCategory == null ? _defaultCategory : _currentCategory,
      frontPanel: _currentCategory == null
          ? UnitConverter(category: _defaultCategory)
          : UnitConverter(category: _currentCategory),
      backPanel: listView,
      frontTitle: Text('Unit Converter'),
      backTitle: Text('Select a Category'),
    );
  }
}

// Use a GridView for landscape mode, passing in the device orientation
// Makes the correct number of rows for the list view, based on wheter the device is portrait or landscape/

// To make the correct number of rows for the list view
// For Portrait mode, use it as a [ListView]
// Widget _buildCategoryWidgets() {
//   return ListView.builder(
//     itemBuilder: (BuildContext context, int index) {
//       return CategoryTile(
//         category: _categories[index],
//         onTap: _onCategoryTap,
//       );
//     },
//     itemCount: _categories.length,
//   );
// }

// // Return a list of mock [Unit]
// List<Unit> _retrieveUnitList(String categoryName) {
//   return List.generate(
//     10,
//     (int i) {
//       i += 1;
//       return Unit(
//         name: '$categoryName Unit $i',
//         conversion: i.toDouble(),
//       );
//     },
//   );
// }

// @override
// Widget build(BuildContext context) {
//   // Import and use the Backdrop widget
//   final listView = Padding(
//     padding: EdgeInsets.only(
//       left: 8.0,
//       right: 8.0,
//       bottom: 48.0,
//     ),
//     child: _buildCategoryWidgets(),
//   );

// Define appbar to use it in the Scaffold below
//   final appBar = AppBar(
//     elevation: 0.0,
//     title: Text(
//       'Unit Converter',
//       style: TextStyle(
//         color: Colors.black,
//         fontSize: 30.0,
//       ),
//     ),
//     centerTitle: true,
//     backgroundColor: _backgroundColor,
//   );

//   return Scaffold(
//     // Use that appBar above
//     appBar: appBar,
//     body: listView,
//   );
// }
// }
