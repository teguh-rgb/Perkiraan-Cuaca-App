class WeatherModel {
  final String city;
  final int temperature;
  final String condition;
  final int humidity;
  final int windSpeed;

  WeatherModel({
    required this.city,
    required this.temperature,
    required this.condition,
    required this.humidity,
    required this.windSpeed,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      city: json['kota'] as String,
      temperature: (json['suhu'] as num).round(),
      condition: json['kondisi'] as String,
      humidity: (json['kelembaban'] as num).round(),
      windSpeed: (json['kecepatan_angin'] as num).round(),
    );
  }
}