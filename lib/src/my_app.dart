import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'services/restaurants.dart';
import 'streambuilder_test.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GoogleMapController _mapController;
  TextEditingController _latitudeController, _longitudeController;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  @override
  void initState() {
    super.initState();
    _latitudeController = TextEditingController();
    _longitudeController = TextEditingController();

    MarkerId markerId = MarkerId(restaurants.center.latitude.toString() +
        restaurants.center.longitude.toString());
    final marker = Marker(
      markerId: markerId,
      position: restaurants.center,
      infoWindow: InfoWindow(
        title: "name",
        snippet: "address",
      ),
      icon: BitmapDescriptor.defaultMarker,
      onTap: () {
        var x = 0;
      },
    );
    markers[markerId] = marker;

    restaurants.init();
  }

  @override
  void dispose() {
    super.dispose();
    restaurants.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var mapLayer = Center(
      child: Card(
        elevation: 4,
        margin: EdgeInsets.symmetric(vertical: 8),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: restaurants.center,
              zoom: 15.0,
            ),
            markers: Set<Marker>.of(markers.values),
          ),
        ),
      ),
    );
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
    var fgLayer = Column(
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
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('GeoFlutterFire'),
          actions: <Widget>[
            IconButton(
              onPressed: _mapController == null
                  ? null
                  : () {
                      _showHome();
                    },
              icon: Icon(Icons.home),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return StreamTestWidget();
            }));
          },
          child: Icon(Icons.navigate_next),
        ),
        body: Stack(
          children: <Widget>[
            mapLayer,
            Container(
              child: Column(
                children: <Widget>[
                  Spacer(),
                  Container(
                    color: Colors.white,
                    height: 240,
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 60),
              child: fgLayer,
            )
          ],
        ),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
//      _showHome();
      //start listening after map is created
      restaurants.stream.listen((List<DocumentSnapshot> documentList) {
        _updateMarkers(documentList);
      });
    });
  }

  void _showHome() {
    _mapController.animateCamera(CameraUpdate.newCameraPosition(
      const CameraPosition(
        target: LatLng(12.960632, 77.641603),
        zoom: 15.0,
      ),
    ));
  }

  void _addMarker(double lat, double lng) {
    MarkerId id = MarkerId(lat.toString() + lng.toString());
    Marker _marker = Marker(
      markerId: id,
      position: LatLng(lat, lng),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
      infoWindow: InfoWindow(title: 'latLng', snippet: '$lat,$lng'),
    );
    setState(() {
      markers[id] = _marker;
    });
  }

  void _updateMarkers(List<DocumentSnapshot> documentList) {
    documentList.forEach((DocumentSnapshot document) {
      GeoPoint point = document.data['position']['geopoint'];
      _addMarker(point.latitude, point.longitude);
    });
  }

  double _value = 20.0;
  String _label = '';

  changed(value) {
    setState(() {
      _value = value;
      _label = '${_value.toInt().toString()} kms';
      markers.clear();
    });
    restaurants.changed(value);
  }
}
