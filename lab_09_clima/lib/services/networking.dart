import 'dart:convert';
import 'package:http/http.dart' as http;
import 'weather_model.dart';

// User can replace with their own OpenWeatherMap API key
const String kApiKey = 'YOUR_OPENWEATHERMAP_API_KEY';
const String kOpenWeatherMapUrl = 'https://api.openweathermap.org/data/2.5/weather';

class NetworkHelper {
  static Future<WeatherData?> getWeatherByCity(String cityName, {String apiKey = kApiKey}) async {
    final cleanCity = cityName.trim();
    if (cleanCity.isEmpty) return null;

    if (apiKey != 'YOUR_OPENWEATHERMAP_API_KEY' && apiKey.isNotEmpty) {
      try {
        final url = Uri.parse('$kOpenWeatherMapUrl?q=$cleanCity&appid=$apiKey&units=metric');
        final response = await http.get(url).timeout(const Duration(seconds: 8));
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body) as Map<String, dynamic>;
          return WeatherData.fromJson(data);
        }
      } catch (_) {
        // Fallback to offline / demo data if request fails
      }
    }

    // Demo / fallback simulation when API key is default or offline
    return _getMockWeatherForCity(cleanCity);
  }

  static Future<WeatherData?> getWeatherByLocation(double latitude, double longitude, {String apiKey = kApiKey}) async {
    if (apiKey != 'YOUR_OPENWEATHERMAP_API_KEY' && apiKey.isNotEmpty) {
      try {
        final url = Uri.parse('$kOpenWeatherMapUrl?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric');
        final response = await http.get(url).timeout(const Duration(seconds: 8));
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body) as Map<String, dynamic>;
          return WeatherData.fromJson(data);
        }
      } catch (_) {
        // Fallback
      }
    }

    return WeatherData.defaultHanoi();
  }

  static WeatherData _getMockWeatherForCity(String cityName) {
    final lower = cityName.toLowerCase();
    if (lower.contains('london')) {
      return WeatherData.defaultLondon();
    } else if (lower.contains('hanoi') || lower.contains('ha noi')) {
      return WeatherData.defaultHanoi();
    } else if (lower.contains('da nang') || lower.contains('danang')) {
      return WeatherData(
        cityName: 'Da Nang',
        countryCode: 'VN',
        localTime: '11:24 PM local time',
        temp: 26,
        feelsLike: 27,
        description: 'scattered clouds',
        humidity: 78,
        windSpeed: 2.1,
        minTemp: 25,
        maxTemp: 28,
        conditionCode: 802,
      );
    } else if (lower.contains('ho chi minh') || lower.contains('saigon')) {
      return WeatherData(
        cityName: 'Ho Chi Minh',
        countryCode: 'VN',
        localTime: '11:24 PM local time',
        temp: 30,
        feelsLike: 33,
        description: 'clear sky',
        humidity: 70,
        windSpeed: 3.5,
        minTemp: 28,
        maxTemp: 32,
        conditionCode: 800,
      );
    } else if (lower.contains('tokyo')) {
      return WeatherData(
        cityName: 'Tokyo',
        countryCode: 'JP',
        localTime: '01:24 AM local time',
        temp: 18,
        feelsLike: 17,
        description: 'light rain',
        humidity: 80,
        windSpeed: 3.2,
        minTemp: 16,
        maxTemp: 20,
        conditionCode: 500,
      );
    } else if (lower.contains('new york')) {
      return WeatherData(
        cityName: 'New York',
        countryCode: 'US',
        localTime: '12:24 PM local time',
        temp: 16,
        feelsLike: 15,
        description: 'clear sky',
        humidity: 50,
        windSpeed: 4.1,
        minTemp: 14,
        maxTemp: 18,
        conditionCode: 800,
      );
    } else if (lower.contains('paris')) {
      return WeatherData(
        cityName: 'Paris',
        countryCode: 'FR',
        localTime: '06:24 PM local time',
        temp: 14,
        feelsLike: 13,
        description: 'broken clouds',
        humidity: 68,
        windSpeed: 3.8,
        minTemp: 12,
        maxTemp: 16,
        conditionCode: 803,
      );
    }

    // Default capitalized city mock
    final capitalized = cityName[0].toUpperCase() + (cityName.length > 1 ? cityName.substring(1) : '');
    return WeatherData(
      cityName: capitalized,
      countryCode: '',
      localTime: '12:00 PM local time',
      temp: 24,
      feelsLike: 24,
      description: 'moderate clouds',
      humidity: 75,
      windSpeed: 2.5,
      minTemp: 22,
      maxTemp: 26,
      conditionCode: 802,
    );
  }
}
