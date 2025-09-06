import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:location/location.dart';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> {
  double? _heading;
  double? _qiblaDirection;
  double _matchPercentage = 0;
  LocationData? _locationData;
  final Location _location = Location();
  String _directionText = '';
  String _instructionText = 'Finding your location...';

  @override
  void initState() {
    super.initState();
    _initLocation();
    FlutterCompass.events!.listen((CompassEvent event) {
      setState(() {
        _heading = event.heading;
        _calculateMatchPercentage();
        _updateDirectionText();
      });
    });
  }

  Future<void> _initLocation() async {
    final permission = await _location.requestPermission();
    if (permission == PermissionStatus.granted) {
      final locData = await _location.getLocation();
      setState(() {
        _locationData = locData;
        _qiblaDirection = _calculateQiblaDirection(
          locData.latitude!,
          locData.longitude!,
        );
        _instructionText = 'Face your phone flat and rotate towards Qibla';
      });
    } else {
      setState(() {
        _instructionText = 'Location permission required to find Qibla';
      });
    }
  }

  double _calculateQiblaDirection(double lat, double lon) {
    // Kaaba location in Makkah (21.4225° N, 39.8262° E)
    const double kaabaLat = 21.4225;
    const double kaabaLon = 39.8262;

    double phiK = _degToRad(kaabaLat);
    double lambdaK = _degToRad(kaabaLon);
    double phi = _degToRad(lat);
    double lambda = _degToRad(lon);

    double deltaLambda = lambdaK - lambda;

    double angle = atan2(
      sin(deltaLambda),
      cos(phi) * tan(phiK) - sin(phi) * cos(deltaLambda),
    );

    return (_radToDeg(angle) + 360) % 360;
  }

  void _calculateMatchPercentage() {
    if (_heading == null || _qiblaDirection == null) return;
    double diff = (_heading! - _qiblaDirection!).abs();
    if (diff > 180) diff = 360 - diff;

    // within 0-5 degrees is excellent alignment (for prayer)
    double percent = (1 - (diff / 5)).clamp(0.0, 1.0) * 100;
    _matchPercentage = percent;
  }

  void _updateDirectionText() {
    if (_qiblaDirection == null || _heading == null) return;

    double diff = (_qiblaDirection! - _heading! + 360) % 360;

    if (_matchPercentage > 95) {
      _directionText = 'Facing Qibla';
    } else if (diff < 45 || diff > 315) {
      _directionText = 'Turn slightly right';
    } else if (diff >= 45 && diff < 135) {
      _directionText = 'Turn right';
    } else if (diff >= 135 && diff < 225) {
      _directionText = 'Turn around';
    } else {
      _directionText = 'Turn left';
    }
  }

  double _degToRad(double deg) => deg * pi / 180;
  double _radToDeg(double rad) => rad * 180 / pi;

  @override
  Widget build(BuildContext context) {
    final compassRotation = ((_heading ?? 0) * (pi / 180) * -1);
    final qiblaNeedleRotation = ((_qiblaDirection ?? 0) - (_heading ?? 0)) * (pi / 180);

    final Color needleColor = _matchPercentage > 95
        ? Colors.green
        : (_matchPercentage > 60 ? Colors.orange : Colors.red);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Qibla Compass'),
        centerTitle: true,
        backgroundColor: Colors.green.shade700,
      ),
      body: _locationData == null || _qiblaDirection == null
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            Text(
              _instructionText,
              style: const TextStyle(fontSize: 16),
            ),
            if (_instructionText.contains('permission'))
              TextButton(
                onPressed: _initLocation,
                child: const Text('Grant Permission'),
              ),
          ],
        ),
      )
          : Column(
        children: [
          const SizedBox(height: 20),
          Text(
            _instructionText,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            'Makkah is to your $_directionText',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Compass Base
                  Transform.rotate(
                    angle: compassRotation,
                    child: Image.asset(
                      'assets/images/spiritual/islam/compass_new.png',
                      width: 400,
                      height: 400,
                    ),
                  ),

                  // Qibla Needle
                  Transform.rotate(
                    angle: qiblaNeedleRotation,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 4,
                          height: 120,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                needleColor.withOpacity(0.8),
                                Colors.transparent,
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        Icon(
                          Icons.location_on,
                          color: needleColor,
                          size: 30,
                        ),
                      ],
                    ),
                  ),

                  // Center marker with Kaaba icon
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.amber,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.mosque,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Information Panel
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Column(
              children: [
                Text(
                  'Qibla Direction: ${_qiblaDirection?.toStringAsFixed(1)}°',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Accuracy: ${_matchPercentage.toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: needleColor,
                  ),
                ),
                const SizedBox(height: 10),
                if (_matchPercentage >= 95)
                  const Column(
                    children: [
                      Text(
                        '✅ Perfectly aligned with Qibla',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.green,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'You can now perform your Salah facing the Kaaba',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  )
                else
                  Text(
                    'Adjust your direction until the needle turns green',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
              ],
            ),
          ),

          // Islamic Reminder
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(bottom: 20),
            child: const Text(
              '"So turn your face toward al-Masjid al-Haram."\n(Quran 2:144)',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Colors.green,
              ),
            ),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _initLocation,
      //   backgroundColor: Colors.green,
      //   child: const Icon(Icons.refresh, color: Colors.white),
      // ),
    );
  }
}