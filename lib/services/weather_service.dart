import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/api_keys.dart';

class WeatherService {
  static const _geocodingUrl = 'https://geocode.maps.co/search';
  static const _weatherUrl = 'https://api.open-meteo.com/v1/forecast';

  Future<Weather> fetchWeather(String city, String country) async {
    final geocodingUrl = '$_geocodingUrl?q=$city,$country&api_key=$apiKey';
    final geocodingResponse = await http.get(Uri.parse(geocodingUrl));

    if (geocodingResponse.statusCode == 200) {
      final geocodingData = json.decode(geocodingResponse.body);
      if (geocodingData.isNotEmpty) {
        final lat = geocodingData[0]['lat'];
        final lon = geocodingData[0]['lon'];

        final weatherUrl = '$_weatherUrl?latitude=$lat&longitude=$lon&current_weather=true';
        final weatherResponse = await http.get(Uri.parse(weatherUrl));

        if (weatherResponse.statusCode == 200) {
          final weatherData = json.decode(weatherResponse.body);
          return Weather(
            location: '$city, $country',
            temperature: weatherData['current_weather']['temperature'].toString(),
            weatherCode: weatherData['current_weather']['weathercode'].toString(),
          );
        } else {
          throw Exception('Failed to load weather data');
        }
      } else {
        throw Exception('Location not found');
      }
    } else {
      throw Exception('Failed to load geocoding data');
    }
  }
}
