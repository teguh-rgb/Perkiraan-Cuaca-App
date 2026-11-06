import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherService {
  static const _locations = <_CityLocation>[
    _CityLocation('Bandung', -6.9175, 107.6191),
    _CityLocation('Jakarta', -6.2088, 106.8456),
    _CityLocation('Bogor', -6.5971, 106.8060),
    _CityLocation('Surabaya', -7.2575, 112.7521),
    _CityLocation('Yogyakarta', -7.7956, 110.3695),
  ];

  Future<List<WeatherModel>> fetchWeatherData() async {
    final fallback = await _loadFallbackData();
    try {
      final response = await http
          .get(
            Uri.https('api.open-meteo.com', '/v1/forecast', {
              'latitude': _locations.map((city) => city.latitude).join(','),
              'longitude': _locations.map((city) => city.longitude).join(','),
              'current':
                  'temperature_2m,relative_humidity_2m,weather_code,wind_speed_10m',
              'temperature_unit': 'celsius',
              'wind_speed_unit': 'kmh',
              'timezone': 'Asia/Jakarta',
            }),
          )
          .timeout(const Duration(seconds: 12));

      if (response.statusCode != 200) {
        return fallback;
      }

      final decoded = jsonDecode(response.body);
      if (decoded is! List || decoded.length != _locations.length) {
        return fallback;
      }

      return List<WeatherModel>.generate(_locations.length, (index) {
        final cityData = decoded[index] as Map<String, dynamic>;
        final current = cityData['current'] as Map<String, dynamic>;
        return WeatherModel.fromOpenMeteo(
          city: _locations[index].name,
          current: current,
        );
      });
    } catch (_) {
      return fallback;
    }
  }

  Future<List<WeatherModel>> _loadFallbackData() async {
    final response = await rootBundle.loadString('assets/data/cuaca.json');
    final data = jsonDecode(response) as List<dynamic>;
    return data
        .map((item) => WeatherModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}

class _CityLocation {
  const _CityLocation(this.name, this.latitude, this.longitude);

  final String name;
  final double latitude;
  final double longitude;
}