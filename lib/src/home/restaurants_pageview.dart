import 'package:flutter/material.dart';
import 'package:ieatta/src/models/restaurant.dart';
import 'package:ieatta/src/services/restaurants.dart';

class RestaurantsPageView extends StatefulWidget {
  RestaurantsPageView({Key key}) : super(key: key);

  @override
  _RestaurantsPageViewState createState() => _RestaurantsPageViewState();
}

class _RestaurantsPageViewState extends State<RestaurantsPageView> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: restaurants.restaurantsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Restaurant> restaurants = snapshot.data;
            if (restaurants.isNotEmpty) {
              return Container(
                child: Center(
                  child: Text(restaurants.length.toString(),
                 style: TextStyle(
                   fontSize: 24
                 ),
                  ),
                ),
              );
            } else {
              return Container(
                child: Center(
                  child: Text('Empty list!'),
                ),
              );
            }
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}
