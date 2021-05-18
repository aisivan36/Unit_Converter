import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

// User imports
import 'unit.dart';

// Use an underscore to indicate that these variables are private.
// final _rowHeight = 100.0;
// final _borderRadius = BorderRadius.circular(_rowHeight / 2);

// A custom [Category] widget

// The widget is composed on an [Icon] and [Text]. Tapping on the widget shows a colored of [InkWell] widget.
class Category {
  final String name;
  final ColorSwatch color;
  final List<Unit> units;
  // TODO: Change this icon to a String path to the image asset
  final IconData iconLocation;

  ///Information about a [Category]

  /// [Category] saves the name of the Category (e.g. ''Length'), a list of its color for the UI, the units for conversions (e.g. 'Millimeter', 'Meter'),and the icon that represents it (e.g. a ruler).
  const Category({
    @required this.name,
    @required this.color,
    @required this.iconLocation,
    @required this.units,
  })  : assert(name != null),
        assert(color != null),
        assert(iconLocation != null),
        assert(units != null);
}

// Navigates to the [ConverterRoute].
//   void _navigateToConverter(BuildContext context) {
//     Navigator.of(context).push(
//       MaterialPageRoute<Null>(
//         builder: (context) {
//           return Scaffold(
//             appBar: AppBar(
//               elevation: 1.0,
//               title: Text(
//                 name,
//                 // display1 is deprecated it should use headline4 instead.
//                 style: Theme.of(context).textTheme.headline4,
//               ),
//               centerTitle: true,
//               backgroundColor: color,
//             ),
//             body: ConverterRoute(
//               color: color,
//               units: units,
//             ),

//             // This prevents the attempt to resize the screen when the keyboard is opened
//             // Resize resizeToAvoidBottomPadding has changed.
//             resizeToAvoidBottomInset: false,
//           );
//         },
//       ),
//     );
//   }

//   // Buillds a custom widget that shows [Category] information.
//   // This information includes the icon, name, and color for the [Category].
//   @override
//   // This 'context' parameter describes the location of this widget in the widget tree. It can be used for obtaining Theme data from the nearest Theme ancestor in the tree. Belowm we obtain the displya1(headline4 instead) text theme.
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.transparent,
//       child: Container(
//         height: _rowHeight,
//         child: InkWell(
//           borderRadius: _borderRadius,
//           // TODO: Use the highlight and splash colors from the ColorSwatch
//           highlightColor: color,
//           splashColor: color,
//           // We cam use either the () => function() or the () { function(); } syntax.
//           onTap: () => _navigateToConverter(context),
//           child: Padding(
//             padding: EdgeInsets.all(8.0),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.stretch,

//               // There are two ways to denote a list: '[]' and 'list()'.
//               // Prefer to use the literal syntax, '[]' instead of 'list()'.
//               // You can add the type argument if you would like, i.e. <Widget>[]
//               children: [
//                 Padding(
//                   padding: EdgeInsets.all(16.0),
//                   child: Icon(
//                     iconLocation,
//                     size: 60.0,
//                   ),
//                 ),
//                 Center(
//                   child: Text(
//                     name, textAlign: TextAlign.center,
//                     // headline is deprecated so that we use headline5 instead
//                     style: Theme.of(context).textTheme.headline5,
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
