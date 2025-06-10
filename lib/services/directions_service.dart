import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../config/env_config.dart';

class DirectionsService {
  static const String _baseUrl = EnvConfig.googleMapsDirectionsUrl;
  static final String _apiKey = EnvConfig.googleMapsApiKey;
  static final _dio = Dio();

  static Future<Map<String, dynamic>> getDirections({
    required LatLng origin,
    required LatLng destination,
  }) async {
    try {
      final response = await _dio.get(
        _baseUrl,
        queryParameters: {
          'origin': '${origin.latitude},${origin.longitude}',
          'destination': '${destination.latitude},${destination.longitude}',
          'mode': 'driving',
          'key': _apiKey,
        },
      );

      final data = response.data;
      if (data['status'] == 'OK' && data['routes'].isNotEmpty) {
        // Print response for debugging
        print('Directions API Response: $data');
        
        final points = _decodePolyline(
          data['routes'][0]['overview_polyline']['points'],
        );
        
        // Print decoded points for debugging
        print('Decoded Points: $points');

        return {
          'polylinePoints': points,
          'distance': data['routes'][0]['legs'][0]['distance']['text'],
          'duration': data['routes'][0]['legs'][0]['duration']['text'],
        };
      }
      throw Exception('Directions API error: ${data['status']}');
    } catch (e) {
      print('Error getting directions: $e');
      rethrow;
    }
  }

  static List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
  }
} 