import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';

class WeatherIconWidget extends StatelessWidget {
  final int weatherCode;

  const WeatherIconWidget({Key? key, required this.weatherCode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BoxedIcon(
      _getWeatherIcon(weatherCode),
      size: 100,
    );
  }

  IconData _getWeatherIcon(int code) {
    switch (code) {
      case 0:
        return WeatherIcons.day_sunny;
      case 1:
      case 2:
      case 3:
        return WeatherIcons.day_cloudy;
      case 45:
      case 48:
        return WeatherIcons.fog;
      case 51:
      case 53:
      case 55:
        return WeatherIcons.drizzle;
      case 56:
      case 57:
        return WeatherIcons.sleet;
      case 61:
      case 63:
      case 65:
        return WeatherIcons.rain;
      case 66:
      case 67:
        return WeatherIcons.rain_mix;
      case 71:
      case 73:
      case 75:
        return WeatherIcons.snow;
      case 77:
        return WeatherIcons.snowflake_cold;
      case 80:
      case 81:
      case 82:
        return WeatherIcons.showers;
      case 85:
      case 86:
        return WeatherIcons.snow_wind;
      case 95:
        return WeatherIcons.thunderstorm;
      case 96:
      case 99:
        return WeatherIcons.storm_showers;
      default:
        return WeatherIcons.na;
    }
  }
}
