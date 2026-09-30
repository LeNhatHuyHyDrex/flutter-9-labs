import 'package:flutter/material.dart';
import '../services/weather_model.dart';
import '../services/networking.dart';
import '../services/location.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _cityController = TextEditingController();
  final LocationService _locationService = LocationService();
  WeatherData _weather = WeatherData.defaultHanoi();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _cityController.text = '';
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _searchCity(String city) async {
    final query = city.trim();
    if (query.isEmpty) return;

    setState(() => _isLoading = true);
    FocusScope.of(context).unfocus();

    final result = await NetworkHelper.getWeatherByCity(query);
    if (result != null) {
      setState(() {
        _weather = result;
      });
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not find weather data for "$query"'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchCurrentLocationWeather() async {
    setState(() => _isLoading = true);
    final success = await _locationService.getCurrentLocation();
    if (success &&
        _locationService.latitude != null &&
        _locationService.longitude != null) {
      final result = await NetworkHelper.getWeatherByLocation(
        _locationService.latitude!,
        _locationService.longitude!,
      );
      if (result != null && mounted) {
        setState(() {
          _weather = result;
        });
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location permission denied or unavailable. Using default.'),
          ),
        );
      }
    }
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEF4FB),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 420),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // App Title
                  const Text(
                    'Weather App',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Search Bar Row
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFFE2E8F0),
                              width: 1.2,
                            ),
                          ),
                          child: TextField(
                            controller: _cityController,
                            textInputAction: TextInputAction.search,
                            onSubmitted: (value) => _searchCity(value),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF1E293B),
                            ),
                            decoration: const InputDecoration(
                              hintText: 'Enter city name (e.g.,...',
                              hintStyle: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF94A3B8),
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                color: Color(0xFF64748B),
                                size: 20,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        height: 48,
                        child: ElevatedButton.icon(
                          onPressed: _isLoading
                              ? null
                              : () => _searchCity(_cityController.text),
                          icon: const Icon(
                            Icons.search,
                            size: 16,
                            color: Colors.white,
                          ),
                          label: const Text(
                            'Search',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2196F3),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  if (_isLoading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: CircularProgressIndicator(),
                    )
                  else ...[
                    // Location info (clickable to refresh GPS location)
                    InkWell(
                      onTap: _fetchCurrentLocationWeather,
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Color(0xFF2196F3),
                                  size: 22,
                                ),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    _weather.locationTitle,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1E293B),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _weather.localTime,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF94A3B8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Weather Icon
                    _buildWeatherIcon(_weather),
                    const SizedBox(height: 12),

                    // Weather Description
                    Text(
                      _weather.description,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF334155),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Main Temperature
                    Text(
                      '${_weather.temp}°C',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Feels like
                    Text(
                      'Feels like ${_weather.feelsLike}°C',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // 4 Detail Cards in 2x2 Grid
                    Row(
                      children: [
                        Expanded(
                          child: _buildDetailCard(
                            icon: Icons.water_drop,
                            iconColor: const Color(0xFF2196F3),
                            title: 'Humidity',
                            value: '${_weather.humidity}%',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildDetailCard(
                            icon: Icons.air,
                            iconColor: const Color(0xFF00BCD4),
                            title: 'Wind Speed',
                            value: '${_weather.windSpeed} m/s',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildDetailCard(
                            icon: Icons.device_thermostat,
                            iconColor: const Color(0xFF2196F3),
                            title: 'Min Temp',
                            value: '${_weather.minTemp}°C',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildDetailCard(
                            icon: Icons.device_thermostat,
                            iconColor: const Color(0xFF2196F3),
                            title: 'Max Temp',
                            value: '${_weather.maxTemp}°C',
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherIcon(WeatherData weather) {
    if (weather.conditionCode == 801 || weather.conditionCode == 802) {
      return SizedBox(
        height: 70,
        width: 80,
        child: Stack(
          alignment: Alignment.center,
          children: const [
            Positioned(
              left: 12,
              top: 4,
              child: Icon(
                Icons.wb_sunny,
                size: 36,
                color: Color(0xFF2196F3),
              ),
            ),
            Positioned(
              right: 8,
              bottom: 4,
              child: Icon(
                Icons.cloud,
                size: 52,
                color: Color(0xFF2196F3),
              ),
            ),
          ],
        ),
      );
    }

    return Icon(
      weather.getWeatherIcon(),
      size: 70,
      color: const Color(0xFF2196F3),
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFEEF2F6),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 20,
              color: iconColor,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF334155),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
