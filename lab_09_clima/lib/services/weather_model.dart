import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeatherData {
  final String cityName;
  final String countryCode;
  final String localTime;
  final int temp;
  final int feelsLike;
  final String description;
  final int humidity;
  final double windSpeed;
  final int minTemp;
  final int maxTemp;
  final int conditionCode;

  WeatherData({
    required this.cityName,
    required this.countryCode,
    required this.localTime,
    required this.temp,
    required this.feelsLike,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.minTemp,
    required this.maxTemp,
    required this.conditionCode,
  });

  String get locationTitle {
    if (countryCode.isNotEmpty) {
      return '$cityName, $countryCode';
    }
    return cityName;
  }

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    final cityName = json['name'] as String? ?? 'Unknown';
    final sys = json['sys'] as Map<String, dynamic>? ?? {};
    final countryCode = sys['country'] as String? ?? '';

    // Calculate local time from timezone offset (in seconds)
    final timezoneOffsetSeconds = json['timezone'] as int? ?? 0;
    final nowUtc = DateTime.now().toUtc();
    final localDateTime = nowUtc.add(Duration(seconds: timezoneOffsetSeconds));
    final formattedTime =
        '${DateFormat('hh:mm a').format(localDateTime)} local time';

    final main = json['main'] as Map<String, dynamic>? ?? {};
    final temp = (main['temp'] as num?)?.round() ?? 0;
    final feelsLike = (main['feels_like'] as num?)?.round() ?? temp;
    final minTemp = (main['temp_min'] as num?)?.round() ?? temp;
    final maxTemp = (main['temp_max'] as num?)?.round() ?? temp;
    final humidity = (main['humidity'] as num?)?.round() ?? 0;

    final wind = json['wind'] as Map<String, dynamic>? ?? {};
    final windSpeed = (wind['speed'] as num?)?.toDouble() ?? 0.0;

    final weatherList = json['weather'] as List<dynamic>? ?? [];
    final weatherFirst = weatherList.isNotEmpty
        ? (weatherList[0] as Map<String, dynamic>)
        : <String, dynamic>{};
    final description =
        (weatherFirst['description'] as String?)?.toLowerCase() ??
            'clear sky';
    final conditionCode = (weatherFirst['id'] as int?) ?? 800;

    return WeatherData(
      cityName: cityName,
      countryCode: countryCode,
      localTime: formattedTime,
      temp: temp,
      feelsLike: feelsLike,
      description: description,
      humidity: humidity,
      windSpeed: windSpeed,
      minTemp: minTemp,
      maxTemp: maxTemp,
      conditionCode: conditionCode,
    );
  }

  IconData getWeatherIcon() {
    if (conditionCode < 300) {
      return Icons.thunderstorm;
    } else if (conditionCode < 400) {
      return Icons.grain;
    } else if (conditionCode < 600) {
      return Icons.water_drop;
    } else if (conditionCode < 700) {
      return Icons.ac_unit;
    } else if (conditionCode < 800) {
      return Icons.cloud_queue;
    } else if (conditionCode == 800) {
      return Icons.wb_sunny;
    } else if (conditionCode <= 802) {
      return Icons.wb_cloudy; // few clouds / scattered clouds
    } else {
      return Icons.cloud; // overcast clouds
    }
  }

  // Pre-configured mock data for default display or demo mode
  static WeatherData defaultHanoi() {
    return WeatherData(
      cityName: 'Hanoi',
      countryCode: 'VN',
      localTime: '11:24 PM local time',
      temp: 22,
      feelsLike: 22,
      description: 'overcast clouds',
      humidity: 84,
      windSpeed: 1.24,
      minTemp: 22,
      maxTemp: 22,
      conditionCode: 804,
    );
  }

  static WeatherData defaultLondon() {
    return WeatherData(
      cityName: 'London',
      countryCode: 'GB',
      localTime: '05:29 PM local time',
      temp: 15,
      feelsLike: 14,
      description: 'few clouds',
      humidity: 62,
      windSpeed: 4.63,
      minTemp: 14,
      maxTemp: 16,
      conditionCode: 801,
    );
  }
}
