import 'package:flutter/material.dart';
import 'package:myapp/features/mainPage/widgets/LocationSearchWidget.dart';
import '../location/models/place_details.dart';

class LocationSearchPage extends StatelessWidget {

  const LocationSearchPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LocationSearchWidget(
          onBackPressed: () => Navigator.of(context).pop(),
          onLocationSelected: (PlaceDetails placeDetails) {
            // Return the selected location data and pop
            Navigator.of(context).pop(placeDetails);
          },
        ),
      ),
    );
  }
}
