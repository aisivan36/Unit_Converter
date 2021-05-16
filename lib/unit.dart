import 'package:meta/meta.dart';

class Unit {
  // Information about a [Unit]
  final String name;
  final double conversion;

  //  [Unit] stores its name and conversion factor.
  // an example would be 'Meter' and '1.0'/

  const Unit({
    @required this.name,
    @required this.conversion,
  })  : assert(name != null),
        assert(conversion != null);

  // Creats a [Unit] from a JSON object
  Unit.fromJson(Map jsonMap)
      : assert(jsonMap['name'] != null),
        assert(jsonMap['conversion'] != null),
        name = jsonMap['name'],
        conversion = jsonMap['conversion'].toDouble();
}
