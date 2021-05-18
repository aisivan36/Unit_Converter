import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

/// User's imports
import 'category.dart';

// We use an underscore to indicate that these variables are private.
//
const _rowHeight = 100.0;
final _borderRadius = BorderRadius.circular(_rowHeight / 2);

// a [CategoryTile] to display a [Category].
class CategoryTile extends StatelessWidget {
  final Category category;
  final ValueChanged<Category> onTap;

  // The [CategoryTile] shows the name and color of a [Cateogry] for unit conversions.
  // Tapping on it brings you to the unit converter.
  const CategoryTile({
    Key key,
    @required this.category,
    @required this.onTap,
  })  : assert(category != null),
        assert(onTap != null),
        super(key: key);

  // Navigates to the [UnitConverter].
  // void _navigateToConverter(BuildContext context) {
  //   Navigator.of(context).push(MaterialPageRoute<Null>(
  //     builder: (context) {
  //       return Scaffold(
  //         appBar: AppBar(
  //           elevation: 1.0,
  //           title: Text(
  //             category.name,
  //             style: Theme.of(context).textTheme.headline4,
  //           ),
  //           centerTitle: true,
  //           backgroundColor: category.color,
  //         ),
  //         body: UnitConverter(category: category),
  //         // This prevents the attempt to resize the screen when the keyboard is opened
  //         resizeToAvoidBottomInset: false,
  //       );
  //     },
  //   ));
  // }

  /// Builds a custom widget that shows [Category] information.
  //
  /// This information includes the icon, name, and color for the [Cateogry]
  @override

  /// This 'context' parameter describes the location of this widget in the widget tree.
  /// It can be used for obtaining Theme data from the nearest Theme ancestor in the tree. I use obtain the headline4 text theme.
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        height: _rowHeight,
        child: InkWell(
          borderRadius: _borderRadius,
          highlightColor: category.color['highlight'],
          splashColor: category.color['splash'],
          // We can use either the () => function or the () {here is function();}
          // This should call the onTap() passed into the constructor
          onTap: () => onTap(category),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              // There are two ways to denote a list: '[]' and 'List()'.
              // I prefer to use the common literal syntax, i.e. '[]' instead of 'List()'
              // We can add the type argument if we'd like, i.e. <Widget>[].
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  // TODO: Use an Image instead of an Icon.
                  child: Icon(
                    category.iconLocation,
                    size: 60.0,
                  ),
                ),
                Center(
                  child: Text(
                    category.name,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
