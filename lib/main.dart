import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();
  String _temperature = '';
  String _weatherCode = '';
  String _location = '';
  bool _isLoading = false;

  @override
  void dispose() {
    _cityController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  Future<void> _fetchWeather(String city, String country) async {
    setState(() {
      _isLoading = true;
    });

    const apiKey = '68bcd70880f7c981758696okua3f99c';
    final geocodingUrl =
        'https://geocode.maps.co/search?q=$city,$country&api_key=$apiKey';

    try {
      final geocodingResponse = await http.get(Uri.parse(geocodingUrl));

      if (geocodingResponse.statusCode == 200) {
        final geocodingData = json.decode(geocodingResponse.body);
        if (geocodingData.isNotEmpty) {
          final lat = geocodingData[0]['lat'];
          final lon = geocodingData[0]['lon'];

          final weatherUrl =
              'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current_weather=true';

          final weatherResponse = await http.get(Uri.parse(weatherUrl));

          if (weatherResponse.statusCode == 200) {
            final weatherData = json.decode(weatherResponse.body);
            setState(() {
              _temperature =
                  weatherData['current_weather']['temperature'].toString();
              _weatherCode =
                  weatherData['current_weather']['weathercode'].toString();
              _location = '$city, $country';
              _isLoading = false;
            });
          } else {
            // Handle weather API error
            setState(() {
              _isLoading = false;
            });
            print('Failed to load weather data');
          }
        } else {
          // Handle geocoding not found
          setState(() {
            _isLoading = false;
          });
          print('Location not found');
        }
      } else {
        // Handle geocoding API error
        setState(() {
          _isLoading = false;
        });
        print('Failed to load geocoding data');
      }
    } catch (e) {
      // Handle exception
      setState(() {
        _isLoading = false;
      });
      print('An error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Weather App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _cityController,
              decoration: const InputDecoration(
                labelText: 'City',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _countryController,
              decoration: const InputDecoration(
                labelText: 'Country',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final city = _cityController.text;
                final country = _countryController.text;
                if (city.isNotEmpty && country.isNotEmpty) {
                  _fetchWeather(city, country);
                }
              },
              child: const Text('Get Weather'),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : _location.isEmpty
                    ? Container()
                    : Column(
                        children: [
                          Text(
                            'Current Weather in $_location:',
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Temperature: $_temperature°C',
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Weather Code: $_weatherCode',
                            style: const TextStyle(fontSize: 20),
                          ),
                           const SizedBox(height: 20),
                           Text(
                            getWeatherInterpretation(_weatherCode),
                            style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
          ],
        ),
      ),
    );
  }

  String getWeatherInterpretation(String code) {
    int weatherCode = int.tryParse(code) ?? 0;
    switch (weatherCode) {
      case 0:
        return 'Clear sky';
      case 1:
      case 2:
      case 3:
        return 'Mainly clear, partly cloudy, and overcast';
      case 45:
      case 48:
        return 'Fog and depositing rime fog';
      case 51:
      case 53:
      case 55:
        return 'Drizzle: Light, moderate, and dense intensity';
      case 56:
      case 57:
        return 'Freezing Drizzle: Light and dense intensity';
      case 61:
      case 63:
      case 65:
        return 'Rain: Slight, moderate and heavy intensity';
      case 66:
      case 67:
        return 'Freezing Rain: Light and heavy intensity';
      case 71:
      case 73:
      case 75:
        return 'Snow fall: Slight, moderate, and heavy intensity';
      case 77:
        return 'Snow grains';
      case 80:
      case 81:
      case 82:
        return 'Rain showers: Slight, moderate, and violent';
      case 85:
      case 86:
        return 'Snow showers slight and heavy';
      case 95:
        return 'Thunderstorm: Slight or moderate';
      case 96:
      case 99:
        return 'Thunderstorm with slight and heavy hail';
      default:
        return 'Unknown weather';
    }
  }
}
