import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'category.dart';
import 'unit.dart';

const _padding = EdgeInsets.all(16.0);

// [ConvertRoute] where users can input amounts to convert in one [Unit]
// and retrieve the conversion in another [Unit] for a specific [Category].

// while it is name ConverterRoute, a more apt name would be ConverterScreen,
// because it is responsible for the UI at the route's destination.
class UnitConverter extends StatefulWidget {
  // // Color that is used for this [Category]/
  // final Color color;
  //
  //
  //
  //

// The current [Category] for unit conversion.
  final Category category;

//  Units for this [Category]
  // final List<Unit> units;

  // This [ConverterRoute] requires the color and units to not be null.
  const UnitConverter({
    @required this.category,
  }) : assert(category != null);

  @override
  _UnitConverterState createState() => _UnitConverterState();
}

class _UnitConverterState extends State<UnitConverter> {
  //Set some variables, such as for keeping track of the user's input value and units
  Unit _fromValue;
  Unit _toValue;
  double _inputValue;
  String _convertedValue = '';
  List<DropdownMenuItem> _unitMenuItems;
  bool _showValidationError = false;
  // TODO: Pass this into the TextField into the TextField so htat the input value persists
  final _inputKey = GlobalKey(debugLabel: 'inputText');

  //  Determine wheter you need ot override anything, such as initState()

  @override
  void initState() {
    super.initState();
    _createDropdownMenuItems();
    _setDefaults();
  }
  // _createDropdownMenuItems() and _setDefaults() should also be called
  // each time the user switches [Categories].

  @override
  void didUpdateWidget(UnitConverter old) {
    super.didUpdateWidget(old);
    // We update our [DropdownMenuItem] units when we switch [Categories]/
    if (old.category != widget.category) {
      _createDropdownMenuItems();
      _setDefaults();
    }
  }

// For Creating a fresh list of the [DropdownMenuItem] widgets, given a list of [Unit]s.
  void _createDropdownMenuItems() {
    var newItems = <DropdownMenuItem>[];
    for (var unit in widget.category.units) {
      newItems.add(
        DropdownMenuItem(
          value: unit.name,
          child: Container(
            child: Text(
              unit.name,
              softWrap: true,
            ),
          ),
        ),
      );
    }
    setState(() {
      _unitMenuItems = newItems;
    });
  }

  // Set the default values for the 'from' and 'to' [Dropdown]s, and the updated output value if a user had previously  entered an input.
  void _setDefaults() {
    setState(() {
      _fromValue = widget.category.units[0];
      _toValue = widget.category.units[1];
    });
    if (_inputValue != null) {
      _updateConversion();
    }
  }

  // Clean up conversion: trim trailing zeros, e.g. 5.500 -> 5.5, 10.0 -> 10
  String _format(double conversion) {
    var outputNum = conversion.toStringAsPrecision(7);
    if (outputNum.contains('.') && outputNum.endsWith(('0'))) {
      var i = outputNum.length - 1;
      while (outputNum[i] == '0') {
        i -= 1;
      }
      outputNum = outputNum.substring(0, i + 1);
    }
    if (outputNum.endsWith('.')) {
      return outputNum.substring(0, outputNum.length - 1);
    }
    return outputNum;
  }

  void _updateConversion() {
    setState(() {
      _convertedValue =
          _format(_inputValue * (_toValue.conversion / _fromValue.conversion));
    });
  }

  void _updateInputValue(String input) {
    setState(() {
      if (input == null || input.isEmpty) {
        _convertedValue = '';
      } else {
        // Although we're using the numerical keyboard, we still have to check for non-numerical input such as '9..0' and '9 -9'

        try {
          final inputDouble = double.parse(input);
          _showValidationError = false;
          _inputValue = inputDouble;
          _updateConversion();
        } on Exception catch (erorr_message) {
          print('Error: $erorr_message');
          _showValidationError = true;
        }
      }
    });
  }

  Unit _getUnit(String unitName) {
    return widget.category.units.firstWhere(
      (Unit unit) => unit.name == unitName,
      orElse: null,
    );
  }

  void _updateFromConversion(dynamic unitName) {
    setState(() {
      _fromValue = _getUnit(unitName);
    });
    if (_inputValue != null) {
      _updateConversion();
    }
  }

  void _updateToConversion(dynamic unitName) {
    setState(() {
      _toValue = _getUnit(unitName);
    });
    if (_inputValue != null) {
      _updateConversion();
    }
  }

  Widget _createDropdown(String currentValue, ValueChanged<dynamic> onChanged) {
    return Container(
      margin: EdgeInsets.only(top: 16.0),
      decoration: BoxDecoration(
        // This sets the color of the [DropdownButton] itself
        color: Colors.grey[50],
        border: Border.all(
          color: Colors.grey[400],
          width: 1.0,
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Theme(
        // This sets the color of the [DropdownMenuItem]
        data: Theme.of(context).copyWith(
          canvasColor: Colors.grey[50],
        ),
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton(
              value: currentValue,
              items: _unitMenuItems,
              onChanged: onChanged,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Create the 'input' group of widgets. This is a Column that includes the input value, and 'from' unit [Dropdown].
    final input = Padding(
      padding: _padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // This is the widget that accepts text input. In this case,
          // it accepts numbers and calls the onChanged property on update.

          TextField(
            style: Theme.of(context).textTheme.headline4,
            decoration: InputDecoration(
              labelStyle: Theme.of(context).textTheme.headline4,
              errorText: _showValidationError ? 'Invalid number entered' : null,
              labelText: 'Input',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(0.0),
              ),
            ),
            // Since we only want numerical input, we use a number keyboard.
            // There are also other keyboards for dates, emails, phone numbers, etc.
            keyboardType: TextInputType.number,
            onChanged: _updateInputValue,
          ),
          _createDropdown(_fromValue.name, _updateFromConversion),
        ],
      ),
    );

    //  Create a compare arrows icon.
    final arrows = RotatedBox(
      quarterTurns: 1,
      child: Icon(
        Icons.compare_arrows,
        size: 40.0,
      ),
    );

    //Create the 'output' group of widgets. This is a Column that includes the output value, and 'to' unit [Dropdown].
    final output = Padding(
      padding: _padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InputDecorator(
            child: Text(
              _convertedValue,
              style: Theme.of(context).textTheme.headline4,
            ),
            decoration: InputDecoration(
              labelText: 'Output',
              labelStyle: Theme.of(context).textTheme.headline4,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(0.0),
              ),
            ),
          ),
          _createDropdown(_toValue.name, _updateToConversion)
        ],
      ),
    );

    //Return the input, arrows, and output widgets, wrapped in a Column.
// TODO: Use a ListView instead of a Column
    final converter = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        input,
        arrows,
        output,
      ],
    );

    // TODO: Use an OrientationBuilder to add a width to the unit converter
    // in landscape mode
    return Padding(
      padding: _padding,
      child: converter,
    );
  }
}

// TODO: Delete the below placehodler code.
//     final unitWidgets = widget.units.map((Unit unit) {
//       return Container(
//         color: widget.color,
//         margin: EdgeInsets.all(8.0),
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Text(
//               unit.name,
//               style: Theme.of(context).textTheme.headline5,
//             ),
//             Text(
//               'Conversion: ${unit.conversion}',
//               style: Theme.of(context).textTheme.subtitle1,
//             )
//           ],
//         ),
//       );
//     }).toList();

//     return ListView(
//       children: unitWidgets,
//     );
//   }
// }
