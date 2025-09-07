import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/location_model.dart';
import 'package:weather_app/models/weather_model.dart';

class WeatherApi {
  static const String _apiKey = '68bcd70880f7c981758696okua3f99c';
  static const String _geocodingApiUrl = 'https://geocode.maps.co/search';
  static const String _weatherApiUrl = 'https://api.open-meteo.com/v1/forecast';

  Future<Location> getLocation(String city, String country) async {
    final url = '$_geocodingApiUrl?q=$city,$country&api_key=$_apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data.isNotEmpty) {
        return Location.fromJson(data[0]);
      } else {
        throw Exception('Location not found');
      }
    } else {
      throw Exception('Failed to load geocoding data');
    }
  }

  Future<Weather> getWeather(Location location) async {
    final url =
        '$_weatherApiUrl?latitude=${location.latitude}&longitude=${location.longitude}&current_weather=true';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Weather.fromJson(data);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
