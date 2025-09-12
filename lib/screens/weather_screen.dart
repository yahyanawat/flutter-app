import 'package:flutter/material.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:weather_app/weather_icons.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();
  final _weatherService = WeatherService();

  Weather? _weather;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _cityController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  Future<void> _fetchWeather(String city, String country) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final weather = await _weatherService.fetchWeather(city, country);
      setState(() {
        _weather = weather;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue, Colors.lightBlueAccent],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: _buildWeatherInfo(),
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: _cityController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'City',
                    labelStyle: const TextStyle(color: Colors.white70),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Colors.white70),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _countryController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Country',
                    labelStyle: const TextStyle(color: Colors.white70),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Colors.white70),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    final city = _cityController.text;
                    final country = _countryController.text;
                    if (city.isNotEmpty && country.isNotEmpty) {
                      _fetchWeather(city, country);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text('Get Weather', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherInfo() {
    if (_isLoading) {
      return const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white));
    }

    if (_errorMessage != null) {
      return Text(
        _errorMessage!,
        key: const ValueKey('error'),
        style: const TextStyle(color: Colors.redAccent, fontSize: 18, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      );
    }

    if (_weather == null) {
      return const Text(
        'Enter a location to get the weather',
        key: ValueKey('welcome'),
        style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w500),
        textAlign: TextAlign.center,
      );
    }

    return Column(
      key: ValueKey('weather'),
      children: [
        Text(
          _weather!.location,
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 10),
        Text(
          '${_weather!.temperature}°C',
          style: const TextStyle(fontSize: 80, fontWeight: FontWeight.w200, color: Colors.white),
        ),
        const SizedBox(height: 10),
        Text(
          getWeatherDescription(_weather!.weatherCode),
          style: const TextStyle(fontSize: 22, color: Colors.white70),
        ),
        const SizedBox(height: 20),
        Icon(
          getWeatherIcon(_weather!.weatherCode),
          size: 100,
          color: Colors.white,
        ),
      ],
    );
  }

  String getWeatherDescription(String code) {
    int weatherCode = int.tryParse(code) ?? 0;
    switch (weatherCode) {
      case 0:
        return 'Clear sky';
      case 1:
      case 2:
      case 3:
        return 'Mainly clear';
      case 45:
      case 48:
        return 'Fog';
      case 51:
      case 53:
      case 55:
        return 'Drizzle';
      case 56:
      case 57:
        return 'Freezing Drizzle';
      case 61:
      case 63:
      case 65:
        return 'Rain';
      case 66:
      case 67:
        return 'Freezing Rain';
      case 71:
      case 73:
      case 75:
        return 'Snow Fall';
      case 77:
        return 'Snow Grains';
      case 80:
      case 81:
      case 82:
        return 'Rain Showers';
      case 85:
      case 86:
        return 'Snow Showers';
      case 95:
        return 'Thunderstorm';
      case 96:
      case 99:
        return 'Thunderstorm';
      default:
        return 'Unknown';
    }
  }

  IconData getWeatherIcon(String code) {
    int weatherCode = int.tryParse(code) ?? 0;
    switch (weatherCode) {
      case 0:
        return WeatherIcons.clearSky;
      case 1:
      case 2:
      case 3:
        return WeatherIcons.mainlyClear;
      case 45:
      case 48:
        return WeatherIcons.fog;
      case 51:
      case 53:
      case 55:
        return WeatherIcons.drizzle;
      case 56:
      case 57:
        return WeatherIcons.freezingDrizzle;
      case 61:
      case 63:
      case 65:
        return WeatherIcons.rain;
      case 66:
      case 67:
        return WeatherIcons.freezingRain;
      case 71:
      case 73:
      case 75:
        return WeatherIcons.snowFall;
      case 77:
        return WeatherIcons.snowGrains;
      case 80:
      case 81:
      case 82:
        return WeatherIcons.rainShowers;
      case 85:
      case 86:
        return WeatherIcons.snowShowers;
      case 95:
        return WeatherIcons.thunderstorm;
      case 96:
      case 99:
        return WeatherIcons.thunderstorm;
      default:
        return WeatherIcons.unknown;
    }
  }
}
