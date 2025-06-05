import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DirectionsService {
  static const String _baseUrl = 'https://maps.googleapis.com/maps/api/directions/json';
  static const String _apiKey = 'AIzaSyDEqusGOuao8qbpjf8Fe-96DtvvAbVeAGc'; // Replace with your API key

  static Future<Map<String, dynamic>> getDirections({
    required LatLng origin,
    required LatLng destination,
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$_baseUrl?origin=${origin.latitude},${origin.longitude}'
          '&destination=${destination.latitude},${destination.longitude}'
          '&mode=driving'
          '&key=$_apiKey',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          // Print response for debugging
          print('Directions API Response: ${response.body}');
          
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
      }
      throw Exception('Failed to fetch directions: ${response.statusCode}');
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