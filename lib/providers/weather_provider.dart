import 'package:flutter/material.dart';
import 'package:weather_app/api/weather_api.dart';
import 'package:weather_app/models/location_model.dart';
import 'package:weather_app/models/weather_model.dart';

class WeatherProvider with ChangeNotifier {
  final WeatherApi _weatherApi = WeatherApi();

  Location? _location;
  Weather? _weather;
  bool _isLoading = false;
  String? _errorMessage;

  Location? get location => _location;
  Weather? get weather => _weather;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchWeather(String city, String country) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final location = await _weatherApi.getLocation(city, country);
      _location = location;

      final weather = await _weatherApi.getWeather(location);
      _weather = weather;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
