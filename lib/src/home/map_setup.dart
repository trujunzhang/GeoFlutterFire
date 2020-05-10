import 'package:flutter/material.dart';

import '../services/restaurants.dart';

class MapSetup extends StatefulWidget {
  MapSetup({Key key}) : super(key: key);

  @override
  _MapSetupState createState() => _MapSetupState();
}

class _MapSetupState extends State<MapSetup> {
  TextEditingController _latitudeController, _longitudeController;

  double _value = 20.0;
  String _label = '';

  @override
  void initState() {
    super.initState();

    _latitudeController = TextEditingController();
    _longitudeController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    var row = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Container(
          width: 100,
          child: TextField(
            controller: _latitudeController,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
                labelText: 'lat',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                )),
          ),
        ),
        Container(
          width: 100,
          child: TextField(
            controller: _longitudeController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                labelText: 'lng',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                )),
          ),
        ),
        MaterialButton(
          color: Colors.blue,
          onPressed: () {
            double lat = double.parse(_latitudeController.text);
            double lng = double.parse(_longitudeController.text);
            restaurants.addPoint(lat, lng);
          },
          child: Text(
            'ADD',
            style: TextStyle(color: Colors.white),
          ),
        )
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Spacer(),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Slider(
            min: 1,
            max: 200,
            divisions: 4,
            value: _value,
            label: _label,
            activeColor: Colors.blue,
            inactiveColor: Colors.blue.withOpacity(0.2),
            onChanged: (double value) => changed(value),
          ),
        ),
        row,
        MaterialButton(
          color: Colors.amber,
          child: Text(
            'Add nested ',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            double lat = double.parse(_latitudeController.text);
            double lng = double.parse(_longitudeController.text);
            restaurants.addNestedPoint(lat, lng);
          },
        )
      ],
    );
  }

  changed(value) {
    setState(() {
      _value = value;
      _label = '${_value.toInt().toString()} kms';
//      markers.clear();
    });
    restaurants.changed(value);
  }
}
