import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../services/restaurants.dart';
import '../streambuilder_test.dart';
import 'google_map_view.dart';
import 'map_setup.dart';
import 'restaurants_pageview.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GoogleMapController _mapController;

  @override
  void initState() {
    super.initState();

    restaurants.init();
  }

  @override
  void dispose() {
    super.dispose();
    restaurants.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            GoogleMapView(),
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
              child: Column(
                children: <Widget>[Spacer(), RestaurantsPageView()],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showHome() {
//    _mapController.animateCamera(CameraUpdate.newCameraPosition(
//      const CameraPosition(
//        target: LatLng(12.960632, 77.641603),
//        zoom: 15.0,
//      ),
//    ));
  }
}
