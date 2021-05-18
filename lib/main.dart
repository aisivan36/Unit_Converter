import 'package:flutter/material.dart';
import 'category_route.dart';

void main() {
  runApp(UnitConverterApp());
}

class UnitConverterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Unit Converter',
      theme: ThemeData(
          //TODO: fill in the fontFamily property
          textTheme: Theme.of(context).textTheme.apply(
                bodyColor: Colors.black,
                displayColor: Colors.grey[400],
              ),

          ///This colors is the [InputOutLineBorder] when it is selected
          primaryColor: Colors.grey[500],
          textSelectionTheme: TextSelectionThemeData(
            selectionHandleColor: Colors.green[500],
          )),
      home: CategoryRoute(),
    );
  }
}
