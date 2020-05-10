import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ieatta/GeoFlutterFire/point.dart';
import 'package:ieatta/GeoFlutterFire/geoflutterfire.dart';
import 'package:ieatta/src/models/restaurant.dart';
import 'package:rxdart/rxdart.dart';

import 'firestore_service.dart';

class Restaurants {
  final _firestoreService = FirestoreService.instance;

  // firestore init
  Firestore _firestore = Firestore.instance;
  Geoflutterfire geo;
  Stream<List<DocumentSnapshot>> stream;
  var radius = BehaviorSubject<double>.seeded(1.0);

  final LatLng center = const LatLng(45.521563, -122.677433);
  final homeCamera = CameraPosition(
    target: LatLng(12.960632, 77.641603),
    zoom: 15.0,
  );

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  Restaurants() {
    markers = <MarkerId, Marker>{};
    firstMarker();
    geo = Geoflutterfire();
    // GeoFirePoint center = geo.point(latitude: 12.960632, longitude: 77.641603);
  }

  firstMarker() {
    MarkerId markerId =
        MarkerId(center.latitude.toString() + center.longitude.toString());
    final marker = Marker(
      markerId: markerId,
      position: center,
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
  }

  init() {
    geo = Geoflutterfire();
    GeoFirePoint center = geo.point(latitude: 12.960632, longitude: 77.641603);
    stream = radius.switchMap((rad) {
      var collectionReference = _firestore.collection('locations');
//          .where('name', isEqualTo: 'darshan');
      return geo.collection(collectionRef: collectionReference).within(
          center: center, radius: rad, field: 'position', strictMode: true);

      /*
      ****Example to specify nested object****

      var collectionReference = _firestore.collection('nestedLocations');
//          .where('name', isEqualTo: 'darshan');
      return geo.collection(collectionRef: collectionReference).within(
          center: center, radius: rad, field: 'address.location.position');

      */
    });
  }

  void addPoint(double lat, double lng) {
    GeoFirePoint geoFirePoint = geo.point(latitude: lat, longitude: lng);
    _firestore
        .collection('locations')
        .add({'name': 'random name', 'position': geoFirePoint.data}).then((_) {
      print('added ${geoFirePoint.hash} successfully');
    });
  }

  //example to add geoFirePoint inside nested object
  void addNestedPoint(double lat, double lng) {
    GeoFirePoint geoFirePoint = geo.point(latitude: lat, longitude: lng);
    _firestore.collection('nestedLocations').add({
      'name': 'random name',
      'address': {
        'location': {'position': geoFirePoint.data}
      }
    }).then((_) {
      print('added ${geoFirePoint.hash} successfully');
    });
  }

  changed(value) {
    radius.add(value);
  }

  void dispose() {
    radius.close();
  }

  Stream<List<Restaurant>> restaurantsStream() {
    return _firestoreService.collectionStream(
      path: 'restaurants',
      builder: (data, documentId) => Restaurant.fromMap(data, documentId),
    );
  }
}

Restaurants restaurants = Restaurants();
