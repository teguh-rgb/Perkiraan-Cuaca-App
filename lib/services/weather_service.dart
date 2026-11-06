import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/weather_model.dart';

class WeatherService {
  Future<List<WeatherModel>> fetchWeatherData() async {
    final String response = await rootBundle.loadString('assets/data/cuaca.json');
    final List<dynamic> data = json.decode(response);
    return data
        .map((item) => WeatherModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}