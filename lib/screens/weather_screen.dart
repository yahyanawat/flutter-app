import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/providers/weather_provider.dart';
import 'package:weather_app/widgets/weather_icon.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();

  @override
  void dispose() {
    _cityController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  Color _getBackgroundColor(int? weatherCode) {
    if (weatherCode == null) {
      return Colors.blue;
    }
    if (weatherCode >= 200 && weatherCode < 300) {
      return Colors.grey;
    } else if (weatherCode >= 300 && weatherCode < 600) {
      return Colors.lightBlue;
    } else if (weatherCode >= 600 && weatherCode < 700) {
      return Colors.lightBlueAccent;
    } else if (weatherCode >= 700 && weatherCode < 800) {
      return Colors.grey[400]!;
    } else if (weatherCode == 800) {
      return Colors.blue[300]!;
    } else if (weatherCode > 800) {
      return Colors.blueGrey;
    }
    return Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherProvider>(
      builder: (context, provider, child) {
        if (provider.errorMessage != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(provider.errorMessage!),
                backgroundColor: Colors.red,
              ),
            );
          });
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text('Flutter Weather App'),
            backgroundColor: _getBackgroundColor(provider.weather?.weatherCode),
          ),
          backgroundColor: _getBackgroundColor(provider.weather?.weatherCode),
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
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _countryController,
                  decoration: const InputDecoration(
                    labelText: 'Country',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    final city = _cityController.text;
                    final country = _countryController.text;
                    if (city.isNotEmpty && country.isNotEmpty) {
                      Provider.of<WeatherProvider>(context, listen: false)
                          .fetchWeather(city, country);
                    }
                  },
                  child: const Text('Get Weather'),
                ),
                const SizedBox(height: 20),
                if (provider.isLoading)
                  const CircularProgressIndicator()
                else if (provider.weather != null)
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          provider.location!.name,
                          style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        WeatherIconWidget(
                            weatherCode: provider.weather!.weatherCode),
                        const SizedBox(height: 20),
                        Text(
                          '${provider.weather!.temperature.toStringAsFixed(1)}°C',
                          style: const TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          provider.weather!.weatherInterpretation,
                          style: const TextStyle(
                              fontSize: 20, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
