import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static final String apiUrl = dotenv.env['API_URL']!;
  static final String googleMapsApiKey = dotenv.env['GOOGLE_MAPS_API_KEY']!;

  // Google Maps Config
  static const String googleMapsDirectionsUrl = 'https://maps.googleapis.com/maps/api/directions/json';
}