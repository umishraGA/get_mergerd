import 'package:flutter/material.dart';
import 'package:myapp/features/mainPage/widgets/LocationSearchWidget.dart';

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
        ),
      ),
    );
  }
}
