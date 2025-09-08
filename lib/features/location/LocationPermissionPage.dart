import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/dio/auth_helper.dart';
import 'models/place_details.dart';
import 'services/places_api_service.dart';

class LocationPermissionPage extends StatefulWidget {
  final VoidCallback? onPermissionGranted;
  final VoidCallback? onPermissionDenied;
  final bool isMandatory;

  const LocationPermissionPage({
    super.key,
    this.onPermissionGranted,
    this.onPermissionDenied,
    this.isMandatory = false,
  });

  @override
  State<LocationPermissionPage> createState() => _LocationPermissionPageState();
}

class _LocationPermissionPageState extends State<LocationPermissionPage> {
  bool _isLoading = false;
  bool _isFetchingLocation = false;
  String? _errorMessage;
  final PlacesApiService _placesService = PlacesApiService();

  @override
  void initState() {
    super.initState();
    _checkPermissionStatus();
  }

  Future<void> _checkPermissionStatus() async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always || 
        permission == LocationPermission.whileInUse) {
      await _getCurrentLocationAndSave();
    }
  }

  Future<void> _saveLocationToPrefs(double latitude, double longitude, {String? locationText, String? formattedAddress}) async {
    try {
      // Validate coordinates before saving
      if (latitude == 0.0 && longitude == 0.0) {
        debugPrint('LocationPermissionPage: Refusing to save invalid coordinates (0.0, 0.0)');
        throw Exception('Invalid coordinates - cannot save (0.0, 0.0)');
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('user_latitude', latitude);
      await prefs.setDouble('user_longitude', longitude);
      await prefs.setString('location_updated_at', DateTime.now().toIso8601String());
      
      // Save location text if available
      if (locationText != null) {
        await prefs.setString('user_location_name', locationText);
        // Also save to the keys that top bar reads from
        await prefs.setString('selected_location_name', locationText);
      }
      if (formattedAddress != null) {
        await prefs.setString('user_location_address', formattedAddress);
        // Also save to the keys that top bar reads from
        await prefs.setString('selected_location_address', formattedAddress);
      }

      debugPrint('LocationPermissionPage: Successfully saved location: $latitude, $longitude');
    } catch (e) {
      debugPrint('Error saving location to SharedPreferences: $e');
      rethrow; // Re-throw so caller knows saving failed
    }
  }

  Future<void> _getLocationTextFromCoordinates(double latitude, double longitude) async {
    try {
      // Add timeout to prevent long loading times
      final places = await _placesService.reverseGeocode(
        latitude: latitude,
        longitude: longitude,
      ).timeout(
        const Duration(seconds: 8), // 8 second timeout for reverse geocoding
        onTimeout: () {
          debugPrint('Reverse geocoding timed out, saving coordinates only');
          return <PlaceDetails>[];
        },
      );
      
      if (places.isNotEmpty) {
        final place = places.first;
        await _saveLocationToPrefs(
          latitude, 
          longitude, 
          locationText: place.name,
          formattedAddress: place.formattedAddress,
        );
        
        // Save additional location details for top bar compatibility
        final prefs = await SharedPreferences.getInstance();
        await prefs.setDouble('selected_latitude', latitude);
        await prefs.setDouble('selected_longitude', longitude);
        await prefs.setString('selected_place_id', place.placeId);
        
        debugPrint('Location resolved: ${place.name} - ${place.formattedAddress}');
      } else {
        // Save coordinates without text if no places found or timeout
        await _saveLocationToPrefs(latitude, longitude);
      }
    } catch (e) {
      debugPrint('Error getting location text: $e');
      // Save coordinates without text if reverse geocoding fails
      await _saveLocationToPrefs(latitude, longitude);
    }
  }

  Future<void> _getCurrentLocationAndSave() async {
    setState(() {
      _isFetchingLocation = true;
      _errorMessage = null;
    });

    try {
      // Try medium accuracy first with longer timeout
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 20), // Increased timeout for better reliability
      );

      // Validate coordinates - reject if they are 0.0 or invalid
      if (position.latitude == 0.0 && position.longitude == 0.0) {
        debugPrint('LocationPermissionPage: Got invalid coordinates (0.0, 0.0), retrying with high accuracy...');

        // Retry with high accuracy if we got invalid coordinates
        final retryPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: const Duration(seconds: 25), // Longer timeout for high accuracy retry
        );

        if (retryPosition.latitude == 0.0 && retryPosition.longitude == 0.0) {
          throw Exception('Unable to get valid coordinates - received (0.0, 0.0)');
        }

        // Use retry position if valid
        await _getLocationTextFromCoordinates(retryPosition.latitude, retryPosition.longitude);
        debugPrint('LocationPermissionPage: Successfully got valid coordinates on retry: ${retryPosition.latitude}, ${retryPosition.longitude}');
      } else {
        // Use original position if valid
        await _getLocationTextFromCoordinates(position.latitude, position.longitude);
        debugPrint('LocationPermissionPage: Got valid coordinates: ${position.latitude}, ${position.longitude}');
      }

      await AuthHelper.savePermissionStatus(true);
      
      setState(() {
        _isFetchingLocation = false;
      });

      widget.onPermissionGranted?.call();
      
    } catch (e) {
      debugPrint('LocationPermissionPage: Error getting location with medium accuracy: $e');

      // If medium accuracy fails, try with low accuracy for faster fix
      try {
        debugPrint('LocationPermissionPage: Trying with low accuracy as fallback...');
        final fallbackPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low, // Use low accuracy for faster results
          timeLimit: const Duration(seconds: 15), // Shorter timeout for low accuracy
        );

        // Validate fallback coordinates
        if (fallbackPosition.latitude == 0.0 && fallbackPosition.longitude == 0.0) {
          throw Exception('Unable to get valid coordinates - received (0.0, 0.0)');
        }

        // Use fallback position if valid
        await _getLocationTextFromCoordinates(fallbackPosition.latitude, fallbackPosition.longitude);
        await AuthHelper.savePermissionStatus(true);

        setState(() {
          _isFetchingLocation = false;
        });

        debugPrint('LocationPermissionPage: Successfully got location with low accuracy: ${fallbackPosition.latitude}, ${fallbackPosition.longitude}');
        widget.onPermissionGranted?.call();
        return;

      } catch (fallbackError) {
        debugPrint('LocationPermissionPage: Fallback also failed: $fallbackError');
        setState(() {
          _errorMessage = 'Unable to get your location. Please ensure GPS is enabled and try again. Error: ${e.toString()}';
          _isFetchingLocation = false;
        });

        // Don't save permission status as successful if we can't get valid coordinates
        // Let user retry instead
        widget.onPermissionDenied?.call();
      }
    }
  }

  Future<void> _requestLocationPermission() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _errorMessage = 'Location services are disabled. Please enable them in your device settings.';
          _isLoading = false;
        });
        return;
      }

      // Check current permission status
      LocationPermission permission = await Geolocator.checkPermission();
      
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _errorMessage = 'Location permission was denied. You can grant permission in Settings to enable location features.';
            _isLoading = false;
          });
          widget.onPermissionDenied?.call();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _errorMessage = 'Location permission permanently denied. Please enable it in app settings.';
          _isLoading = false;
        });
        widget.onPermissionDenied?.call();
        return;
      }

      // Permission granted - now get current location
      setState(() {
        _isLoading = false;
      });
      await _getCurrentLocationAndSave();
      
    } catch (e) {
      setState(() {
        _errorMessage = 'Error requesting location permission: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _openAppSettings() async {
    await Geolocator.openAppSettings();
    // When user returns from settings, check permission status again
    await Future.delayed(const Duration(milliseconds: 500)); // Small delay to ensure settings are applied
    setState(() {
      _errorMessage = null; // Clear previous error message
    });
    await _checkPermissionStatus();
  }

  String get _platformSpecificMessage {
    if (Platform.isIOS) {
      return 'This app needs access to your location to provide personalized content and services. Your location data will be used to show nearby businesses and improve your experience.';
    } else {
      return 'Allow this app to access your device\'s location to find nearby businesses and services. This will help us provide more relevant content for your area.';
    }
  }

  String get _platformSpecificButtonText {
    if (Platform.isIOS) {
      return 'Allow Location Access';
    } else {
      return 'Grant Location Permission';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Header with back button (only if not mandatory)
              Row(
                children: [
                  if (!widget.isMandatory)
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back_ios),
                      color: Colors.black87,
                    ),
                  Expanded(
                    child: Text(
                      widget.isMandatory ? 'Permission Required' : 'Location Permission',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if (!widget.isMandatory)
                    const SizedBox(width: 48), // Balance the back button
                ],
              ),
              
              const SizedBox(height: 40),
              
              // Location icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(60),
                ),
                child: const Icon(
                  Icons.location_on,
                  size: 60,
                  color: Color(0xFF1976D2),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Title
              Text(
                widget.isMandatory 
                    ? 'Location Access Required'
                    : 'Location Access Required',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 16),
              
              // Platform-specific description
              Text(
                widget.isMandatory 
                    ? 'Location access is required to use this app. We need your location to provide personalized content, find nearby businesses, and enhance your experience.'
                    : _platformSpecificMessage,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 32),
              
              // Benefits list
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  children: [
                    _BenefitItem(
                      icon: Icons.store,
                      text: 'Find nearby businesses and services',
                    ),
                    SizedBox(height: 16),
                    _BenefitItem(
                      icon: Icons.local_offer,
                      text: 'Get location-based offers and discounts',
                    ),
                    SizedBox(height: 16),
                    _BenefitItem(
                      icon: Icons.navigation,
                      text: 'Accurate directions and distance information',
                    ),
                  ],
                ),
              ),
              
              const Spacer(),
              
              // Error message
              if (_errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEBEE),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE57373)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Color(0xFFD32F2F),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(
                            color: Color(0xFFD32F2F),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              
              // Action buttons
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: (_isLoading || _isFetchingLocation) ? null : () {
                        // If there's a location error, retry getting location directly
                        if (_errorMessage != null && _errorMessage!.contains('Unable to get your location')) {
                          _getCurrentLocationAndSave();
                        } else {
                          _requestLocationPermission();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1976D2),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: (_isLoading || _isFetchingLocation)
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              _isFetchingLocation 
                                  ? 'Getting your location...\n(This may take up to 30 seconds)'
                                  : (_errorMessage != null && _errorMessage!.contains('Unable to get your location'))
                                      ? 'Retry Location'
                                      : _platformSpecificButtonText,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                  
                  if (_errorMessage != null && 
                      (_errorMessage!.contains('denied') || _errorMessage!.contains('permanently denied')))
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: OutlinedButton(
                          onPressed: _openAppSettings,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF1976D2),
                            side: const BorderSide(color: Color(0xFF1976D2)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Open App Settings',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  
                  const SizedBox(height: 12),
                  
                  // Only show skip button if not mandatory
                  if (!widget.isMandatory)
                    TextButton(
                      onPressed: () {
                        widget.onPermissionDenied?.call();
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Skip for now',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                      ),
                    ),
                ],
              ),
              
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _BenefitItem extends StatelessWidget {
  final IconData icon;
  final String text;
  
  const _BenefitItem({
    required this.icon,
    required this.text,
  });
  
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF1976D2).withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF1976D2),
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}