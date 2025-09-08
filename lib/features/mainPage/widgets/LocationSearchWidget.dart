import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:myapp/utils/locationUtils/LocationUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../location/models/location_suggestion.dart';
import '../../location/models/place_details.dart';
import '../../location/services/places_api_service.dart';
import '../../address/models/saved_address_models.dart';
import '../../address/services/address_service.dart';

class LocationSearchWidget extends StatefulWidget {
  final VoidCallback onBackPressed;
  final Function(PlaceDetails)? onLocationSelected;

  const LocationSearchWidget({
    super.key,
    required this.onBackPressed,
    this.onLocationSelected,
  });

  @override
  State<LocationSearchWidget> createState() => _LocationSearchWidgetState();
}

class _LocationSearchWidgetState extends State<LocationSearchWidget> {
  final TextEditingController _searchController = TextEditingController();
  final PlacesApiService _placesService = PlacesApiService();
  final FocusNode _searchFocusNode = FocusNode();
  
  List<LocationSuggestion> _suggestions = [];
  List<String> _recentSearches = [];
  List<SavedAddress> _savedAddresses = [];
  bool _isLoading = false;
  bool _showSuggestions = false;
  bool _isDetectingLocation = false;
  bool _isLoadingAddresses = false;
  Timer? _debounceTimer;
<<<<<<< HEAD
=======
  bool _isCancelled = false;
>>>>>>> a12b8cdc96c71b22503145f01065de5b4cacf34b
  String? _currentLocation;
  String _locationName = 'Charbag';
  String _locationAddress = 'current location of user with pin code';
  final AddressService _addressService = AddressService();

  @override
  void initState() {
    super.initState();
    _loadRecentSearches();
    _loadCurrentLocation();
    _loadSelectedLocation();
    _loadSavedAddresses();
    _searchController.addListener(_onSearchChanged);
    _searchFocusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    
    if (query.isEmpty) {
<<<<<<< HEAD
      setState(() {
        _suggestions.clear();
        _showSuggestions = false;
=======
      _isCancelled = true; // Cancel any ongoing requests
      _debounceTimer?.cancel();
      setState(() {
        _suggestions.clear();
        _showSuggestions = false;
        _isLoading = false;
>>>>>>> a12b8cdc96c71b22503145f01065de5b4cacf34b
      });
      return;
    }

<<<<<<< HEAD
    // Cancel previous timer
=======
    // Cancel previous timer and ongoing requests
    _isCancelled = true;
>>>>>>> a12b8cdc96c71b22503145f01065de5b4cacf34b
    _debounceTimer?.cancel();
    
    // Start new timer
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
<<<<<<< HEAD
=======
      _isCancelled = false; // Reset cancel flag for new search
>>>>>>> a12b8cdc96c71b22503145f01065de5b4cacf34b
      _searchPlaces(query);
    });
  }

  void _onFocusChanged() {
    if (_searchFocusNode.hasFocus && _searchController.text.isNotEmpty) {
      setState(() {
        _showSuggestions = true;
      });
    }
  }

  Future<void> _loadRecentSearches() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final searches = prefs.getStringList('recent_location_searches') ?? [];
      setState(() {
        _recentSearches = searches;
      });
    } catch (e) {
      debugPrint('Error loading recent searches: $e');
    }
  }

  Future<void> _loadCurrentLocation() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final latitude = prefs.getDouble('user_latitude');
      final longitude = prefs.getDouble('user_longitude');
      
      if (latitude != null && longitude != null) {
        // You can use reverse geocoding here to get the current location name
        setState(() {
          _currentLocation = 'Current Location';
        });
      }
    } catch (e) {
      debugPrint('Error loading current location: $e');
    }
  }

  Future<void> _loadSelectedLocation() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final name = prefs.getString('selected_location_name');
      final address = prefs.getString('selected_location_address');
      
      if (name != null && address != null) {
        setState(() {
          _locationName = name;
          _locationAddress = address;
        });
      }
    } catch (e) {
      debugPrint('Error loading selected location: $e');
    }
  }

  Future<void> _loadSavedAddresses() async {
    setState(() {
      _isLoadingAddresses = true;
    });

    try {
      final savedAddressResponse = await _addressService.getSavedAddresses();
      setState(() {
        _savedAddresses = savedAddressResponse.data;
        _isLoadingAddresses = false;
      });
      debugPrint('Saved addresses loaded: ${savedAddressResponse.message}');
    } catch (e) {
      setState(() {
        _isLoadingAddresses = false;
      });
      debugPrint('Error loading saved addresses: $e');
      _showError('Failed to load saved addresses: ${e.toString()}');
    }
  }

  Future<void> _saveRecentSearch(String search) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final searches = List<String>.from(prefs.getStringList('recent_location_searches') ?? []);
      
      // Remove if already exists
      searches.remove(search);
      // Add to beginning
      searches.insert(0, search);
      // Keep only last 10 searches
      if (searches.length > 10) {
        searches.removeRange(10, searches.length);
      }
      
      await prefs.setStringList('recent_location_searches', searches);
      setState(() {
        _recentSearches = searches;
      });
    } catch (e) {
      debugPrint('Error saving recent search: $e');
    }
  }

  Future<void> _saveSelectedLocation(PlaceDetails placeDetails) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Save coordinates
      await prefs.setDouble('selected_latitude', placeDetails.latitude);
      await prefs.setDouble('selected_longitude', placeDetails.longitude);

      LocationUtils.saveUserCoordinates(placeDetails.latitude, placeDetails.longitude);
      
      // Save location details
      await prefs.setString('selected_location_name', placeDetails.name);
      await prefs.setString('selected_location_address', placeDetails.formattedAddress);
      await prefs.setString('selected_place_id', placeDetails.placeId);
      
      // Update displayed location immediately
      setState(() {
        _locationName = placeDetails.name;
        _locationAddress = placeDetails.formattedAddress;
      });
      
      debugPrint('Location saved: ${placeDetails.name} (${placeDetails.latitude}, ${placeDetails.longitude})');
    } catch (e) {
      debugPrint('Error saving selected location: $e');
    }
  }

  Future<void> _clearRecentSearches() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('recent_location_searches');
      setState(() {
        _recentSearches.clear();
      });
    } catch (e) {
      debugPrint('Error clearing recent searches: $e');
    }
  }

  Future<void> _searchPlaces(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _showSuggestions = true;
    });

<<<<<<< HEAD
    try {
      // Get user's current location for better suggestions
      final prefs = await SharedPreferences.getInstance();
      final latitude = prefs.getDouble('user_latitude');
      final longitude = prefs.getDouble('user_longitude');

      final suggestions = await _placesService.getAutocompleteSuggestions(
        input: query,
        latitude: latitude,
        longitude: longitude,
        radius: 50000, // 50km radius
        components: 'country:in', // Restrict to India
      );

      setState(() {
        _suggestions = suggestions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _suggestions.clear();
      });
      debugPrint('Error searching places: $e');
=======
    int retryCount = 0;
    const maxRetries = 2;

    while (retryCount <= maxRetries && !_isCancelled) {
      try {
        // Check if cancelled before making API call
        if (_isCancelled) return;

        // Get user's current location for better suggestions
        final prefs = await SharedPreferences.getInstance();
        final latitude = prefs.getDouble('user_latitude');
        final longitude = prefs.getDouble('user_longitude');

        final suggestions = await _placesService.getAutocompleteSuggestions(
          input: query,
          latitude: latitude,
          longitude: longitude,
          radius: 50000, // 50km radius
          components: 'country:in', // Restrict to India
        );

        // Check if cancelled after API call
        if (_isCancelled) return;

        setState(() {
          _suggestions = suggestions;
          _isLoading = false;
        });
        return; // Success - exit retry loop

      } catch (e) {
        debugPrint('Error searching places (attempt ${retryCount + 1}): $e');
        retryCount++;

        if (retryCount > maxRetries) {
          // Final attempt failed
          setState(() {
            _isLoading = false;
            _suggestions.clear();
          });

          // Show user-friendly error message
          if (mounted && e.toString().contains('timeout')) {
            _showError('Search timed out. Please check your internet connection and try again.');
          } else if (mounted && e.toString().contains('OVER_QUERY_LIMIT')) {
            _showError('Too many searches. Please wait a moment and try again.');
          } else if (mounted) {
            _showError('Unable to search locations. Please try again.');
          }
          break;
        } else {
          // Wait before retry
          await Future.delayed(Duration(seconds: retryCount));
        }
      }
>>>>>>> a12b8cdc96c71b22503145f01065de5b4cacf34b
    }
  }

  Future<void> _selectSuggestion(LocationSuggestion suggestion) async {
    setState(() {
      _isLoading = true;
    });

<<<<<<< HEAD
    try {
      // Get place details
      final placeDetails = await _placesService.getPlaceDetails(
        placeId: suggestion.placeId,
      );

      // Save location coordinates and details to SharedPreferences
      await _saveSelectedLocation(placeDetails);

      // Save to recent searches
      await _saveRecentSearch(suggestion.description);

      // Call callback
      widget.onLocationSelected?.call(placeDetails);

      // Update UI
      setState(() {
        _searchController.text = suggestion.description;
        _showSuggestions = false;
        _isLoading = false;
      });

      // Remove focus
      _searchFocusNode.unfocus();

    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      debugPrint('Error selecting place: $e');
      
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to get location details: $e'),
            backgroundColor: Colors.red,
          ),
        );
=======
    int retryCount = 0;
    const maxRetries = 2;

    while (retryCount <= maxRetries) {
      try {
        // Get place details
        final placeDetails = await _placesService.getPlaceDetails(
          placeId: suggestion.placeId,
        );

        // Save location coordinates and details to SharedPreferences
        await _saveSelectedLocation(placeDetails);

        // Save to recent searches
        await _saveRecentSearch(suggestion.description);

        // Call callback
        widget.onLocationSelected?.call(placeDetails);

        // Update UI
        setState(() {
          _searchController.text = suggestion.description;
          _showSuggestions = false;
          _isLoading = false;
        });

        // Remove focus
        _searchFocusNode.unfocus();
        return; // Success - exit retry loop

      } catch (e) {
        debugPrint('Error selecting place (attempt ${retryCount + 1}): $e');
        retryCount++;

        if (retryCount > maxRetries) {
          // Final attempt failed
          setState(() {
            _isLoading = false;
          });

          // Show user-friendly error message
          if (mounted) {
            String errorMessage = 'Failed to get location details.';
            if (e.toString().contains('timeout')) {
              errorMessage = 'Location request timed out. Please try again.';
            } else if (e.toString().contains('OVER_QUERY_LIMIT')) {
              errorMessage = 'Too many requests. Please wait and try again.';
            }

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(errorMessage),
                backgroundColor: Colors.red,
                action: SnackBarAction(
                  label: 'Retry',
                  onPressed: () => _selectSuggestion(suggestion),
                ),
              ),
            );
          }
          break;
        } else {
          // Wait before retry
          await Future.delayed(Duration(seconds: retryCount));
        }
>>>>>>> a12b8cdc96c71b22503145f01065de5b4cacf34b
      }
    }
  }

  void _selectRecentSearch(String search) {
    setState(() {
      _searchController.text = search;
      _showSuggestions = false;
    });
    _searchFocusNode.unfocus();
    _searchPlaces(search);
  }

  Future<void> _autoDetectCurrentLocation() async {
    setState(() {
      _isDetectingLocation = true;
    });

    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showError('Location services are disabled. Please enable them in your device settings.');
        return;
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showError('Location permission was denied.');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showError('Location permission permanently denied. Please enable it in app settings.');
        return;
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 15),
      );

      // Use reverse geocoding to get location details
      final places = await _placesService.reverseGeocode(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      if (places.isNotEmpty) {
        final place = places.first;
        
        // Create PlaceDetails object for the current location
        final currentLocationDetails = PlaceDetails(
          placeId: place.placeId,
          name: place.name,
          formattedAddress: place.formattedAddress,
          latitude: position.latitude,
          longitude: position.longitude,
          types: place.types,
          vicinity: place.vicinity,
          url: place.url,
          website: place.website,
          phoneNumber: place.phoneNumber,
          rating: place.rating,
          userRatingsTotal: place.userRatingsTotal,
        );

        // Save the detected location
        await _saveSelectedLocation(currentLocationDetails);

        // Update search controller to show the location
        setState(() {
          _searchController.text = '${place.name} - Current Location';
          _currentLocation = place.name;
        });

        // Call the callback
        widget.onLocationSelected?.call(currentLocationDetails);

        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Current location detected: ${place.name}'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } else {
        _showError('Could not determine location details');
      }

    } catch (e) {
      debugPrint('Error detecting location: $e');
      _showError('Failed to detect current location: ${e.toString()}');
    } finally {
      setState(() {
        _isDetectingLocation = false;
      });
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _selectSavedAddress(SavedAddress address) {
    try {
      // Parse coordinates
      final latitude = double.parse(address.latitude);
      final longitude = double.parse(address.longitude);

      // Create PlaceDetails object from saved address
      final placeDetails = PlaceDetails(
        placeId: address.id,
        name: address.displayTitle,
        formattedAddress: address.formattedAddress,
        latitude: latitude,
        longitude: longitude,
        types: [address.type],
        vicinity: '${address.city}, ${address.state}',
        url: '',
        website: '',
        phoneNumber: address.mobile.toString(),
        rating: 0.0,
        userRatingsTotal: 0,
      );

      // Save the selected location
      _saveSelectedLocation(placeDetails);

      // Update search controller
      setState(() {
        _searchController.text = address.displayTitle;
        _showSuggestions = false;
      });

      // Remove focus
      _searchFocusNode.unfocus();

      // Call callback
      widget.onLocationSelected?.call(placeDetails);

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Selected: ${address.displayTitle}'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error selecting saved address: $e');
      _showError('Failed to select address: ${e.toString()}');
    }
  }

  IconData _getAddressIcon(String type) {
    switch (type.toLowerCase()) {
      case 'home':
        return Icons.home;
      case 'office':
      case 'offic': // Handle the typo in the API response
        return Icons.business;
      case 'other':
        return Icons.location_on;
      default:
        return Icons.location_on;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Column(
        children: [
          // Header with back button and location
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Back button
                InkWell(
                  onTap: widget.onBackPressed,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFBB9F9F)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Location text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _locationName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          color: Colors.black,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        _locationAddress,
                        style: const TextStyle(
                          color: Color(0xFF909090),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Search input
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFF909090)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: Color(0xFF909090),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      focusNode: _searchFocusNode,
                      decoration: const InputDecoration(
                          hintText: 'Start typing your location',
                          hintStyle: TextStyle(
                              color: Color(0xFF909090),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              backgroundColor: Colors.transparent),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 16),
                          fillColor: Colors.transparent,
                          focusedBorder: InputBorder.none),
                    ),
                  ),
                  if (_isLoading)
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF909090)),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Suggestions list
          if (_showSuggestions && _suggestions.isNotEmpty)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFFE0E0E0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: _suggestions.map((suggestion) {
                  return _buildSuggestionItem(suggestion);
                }).toList(),
              ),
            ),

          // Show static content only when not showing suggestions
          if (!_showSuggestions) ...[
            // Auto-detect location button
          Padding(
            padding: const EdgeInsets.all(16),
            child: GestureDetector(
              onTap: _isDetectingLocation ? null : _autoDetectCurrentLocation,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: _isDetectingLocation 
                      ? const Color(0xFFEAEBFF).withOpacity(0.6)
                      : const Color(0xFFEAEBFF),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _isDetectingLocation 
                          ? 'Detecting your location...'
                          : 'Auto-detect current location',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: _isDetectingLocation 
                            ? const Color(0xFF909090)
                            : Colors.black,
                      ),
                    ),
                    _isDetectingLocation
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF426DB3)),
                            ),
                          )
                        : const Icon(
                            Icons.my_location,
                            color: Color(0xFF426DB3),
                            size: 20,
                          ),
                  ],
                ),
              ),
            ),
          ),

          // Saved address section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'SAVED ADDRESS',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF909090),
                  ),
                ),
                const SizedBox(height: 12),
                if (_isLoadingAddresses)
                  const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF426DB3)),
                    ),
                  )
                else if (_savedAddresses.isEmpty)
                  const Text(
                    'No saved addresses',
                    style: TextStyle(
                      color: Color(0xFF909090),
                      fontSize: 14,
                    ),
                  )
                else
                  ..._savedAddresses.map((address) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GestureDetector(
                      onTap: () => _selectSavedAddress(address),
                      child: _buildAddressItem(
                        icon: _getAddressIcon(address.type),
                        title: address.displayTitle,
                        subtitle: address.formattedAddress,
                      ),
                    ),
                  )).toList(),
              ],
            ),
          ),

          // Recent searches section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'RECENT SEARCHES',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF909090),
                      ),
                    ),
                    GestureDetector(
                      onTap: _clearRecentSearches,
                      child: Text(
                        'Clear',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ..._recentSearches.map((search) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GestureDetector(
                    onTap: () => _selectRecentSearch(search),
                    child: _buildRecentSearchItem(
                      icon: Icons.history,
                      text: search,
                    ),
                  ),
                )).toList(),
                if (_recentSearches.isEmpty)
                  const Text(
                    'No recent searches',
                    style: TextStyle(
                      color: Color(0xFF909090),
                      fontSize: 14,
                    ),
                  ),
              ],
            ),
          ),

          ], // End of conditional static content
        ],
      ),
    );
  }

  Widget _buildAddressItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.grey,
          size: 24,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Color(0xFF909090),
                  fontSize: 14,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecentSearchItem({
    required IconData icon,
    required String text,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.grey,
          size: 24,
        ),
        const SizedBox(width: 16),
        Text(
          text,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildPopularLocalityItem({
    required String text,
    required String distance,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(
              Icons.trending_up,
              color: Colors.grey,
              size: 24,
            ),
            const SizedBox(width: 16),
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
        Text(
          distance,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestionItem(LocationSuggestion suggestion) {
    return InkWell(
      onTap: () => _selectSuggestion(suggestion),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Color(0xFFE0E0E0),
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.location_on,
              color: Color(0xFF909090),
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    suggestion.mainText,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (suggestion.secondaryText.isNotEmpty)
                    Text(
                      suggestion.secondaryText,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF909090),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
