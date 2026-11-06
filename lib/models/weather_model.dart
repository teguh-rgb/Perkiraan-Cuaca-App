class WeatherModel {
  final String city;
  final int temperature;
  final String condition;
  final int humidity;
  final int windSpeed;
  final bool isLive;
  final DateTime? observedAt;

  WeatherModel({
    required this.city,
    required this.temperature,
    required this.condition,
    required this.humidity,
    required this.windSpeed,
    this.isLive = false,
    this.observedAt,
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

  factory WeatherModel.fromOpenMeteo({
    required String city,
    required Map<String, dynamic> current,
  }) {
    return WeatherModel(
      city: city,
      temperature: (current['temperature_2m'] as num).round(),
      condition: conditionForCode((current['weather_code'] as num).toInt()),
      humidity: (current['relative_humidity_2m'] as num).round(),
      windSpeed: (current['wind_speed_10m'] as num).round(),
      isLive: true,
      observedAt: DateTime.tryParse(current['time'] as String),
    );
  }

  static String conditionForCode(int code) {
    if (code == 0) return 'Cerah';
    if (code == 1 || code == 2) return 'Cerah Berawan';
    if (code == 3) return 'Berawan';
    if (code == 45 || code == 48) return 'Berkabut';
    if (code >= 51 && code <= 57) return 'Gerimis';
    if ((code >= 61 && code <= 67) || (code >= 80 && code <= 82)) {
      return 'Hujan';
    }
    if (code >= 71 && code <= 77 || code == 85 || code == 86) {
      return 'Salju';
    }
    if (code >= 95 && code <= 99) return 'Hujan Petir';
    return 'Berawan';
  }
}