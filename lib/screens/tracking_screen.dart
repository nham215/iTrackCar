import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import '../services/directions_service.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  bool _isLoading = true;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  bool _isNavigating = false;
  LatLng? _selectedCarLocation;
  String _distance = '';
  String _duration = '';

  // Example car locations
  final List<Map<String, dynamic>> _carLocations = [
    {
      'id': '1',
      'vin': 'VIN 123',
      'position': const LatLng(12.707644288945298, 108.08152913607368),
    },
    {
      'id': '2',
      'vin': 'VIN 456',
      'position': const LatLng(12.726041525258024, 108.07992081243226),
    },
  ];

  @override
  void initState() {
    super.initState();
    _setupLocationPermission();
  }

  Future<void> _setupLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return;
      }

      final position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentPosition = position;
        _isLoading = false;
      });

      Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      ).listen(_onLocationUpdate);

      _addCarMarkers();
    } catch (e) {
      print('Error setting up location: $e');
    }
  }

  void _onLocationUpdate(Position position) async {
    setState(() {
      _currentPosition = position;
    });

    if (_isNavigating && _selectedCarLocation != null) {
      await _updateDirections();
    }
  }

  void _addCarMarkers() {
    setState(() {
      _markers = _carLocations.map((car) {
        return Marker(
          markerId: MarkerId(car['id']),
          position: car['position'],
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          infoWindow: InfoWindow(
            title: car['vin'],
            snippet: 'Click to navigate',
            onTap: () => _startNavigation(car['position']),
          ),
        );
      }).toSet();
    });
  }

  Future<void> _startNavigation(LatLng carLocation) async {
    if (_currentPosition == null) return;

    setState(() {
      _isNavigating = true;
      _selectedCarLocation = carLocation;
    });

    await _updateDirections();

    _mapController?.animateCamera(
      CameraUpdate.newLatLngBounds(
        _getBounds(_currentPosition!, carLocation),
        50,
      ),
    );
  }

  Future<void> _updateDirections() async {
    if (_currentPosition == null || _selectedCarLocation == null) return;

    try {
      final directions = await DirectionsService.getDirections(
        origin: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        destination: _selectedCarLocation!,
      );

      setState(() {
        _polylines = {
          Polyline(
            polylineId: const PolylineId('navigation'),
            points: directions['polylinePoints'],
            color: Colors.orange,
            width: 4,
          ),
        };
        _distance = directions['distance'];
        _duration = directions['duration'];
      });
    } catch (e) {
      print('Error getting directions: $e');
    }
  }

  LatLngBounds _getBounds(Position userLocation, LatLng carLocation) {
    final userLatLng = LatLng(userLocation.latitude, userLocation.longitude);
    final List<LatLng> points = [userLatLng, carLocation];
    
    double minLat = userLatLng.latitude;
    double maxLat = userLatLng.latitude;
    double minLng = userLatLng.longitude;
    double maxLng = userLatLng.longitude;
    
    for (final point in points) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }
    
    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    if (_currentPosition != null) {
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
            zoom: 15,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_currentPosition == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            'Unable to get location. Please enable location services.',
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
              zoom: 15,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            mapType: MapType.normal,
            zoomControlsEnabled: false,
            compassEnabled: true,
            markers: _markers,
            polylines: _polylines,
          ),
          if (_isNavigating && _selectedCarLocation != null)
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.directions_car,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Navigating to car',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        if (_distance.isNotEmpty && _duration.isNotEmpty)
                          Text(
                            '$_distance • $_duration',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _isNavigating = false;
                          _selectedCarLocation = null;
                          _polylines.clear();
                          _distance = '';
                          _duration = '';
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
} 