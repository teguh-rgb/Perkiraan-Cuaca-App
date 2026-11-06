import 'package:flutter_test/flutter_test.dart';
import 'package:prakiraan_cuaca/models/weather_model.dart';

void main() {
  group('WeatherModel.conditionForCode', () {
    test('maps clear and cloudy WMO codes to Indonesian labels', () {
      expect(WeatherModel.conditionForCode(0), 'Cerah');
      expect(WeatherModel.conditionForCode(2), 'Cerah Berawan');
      expect(WeatherModel.conditionForCode(3), 'Berawan');
    });

    test('maps rain and thunderstorm codes to the expected conditions', () {
      expect(WeatherModel.conditionForCode(51), 'Gerimis');
      expect(WeatherModel.conditionForCode(65), 'Hujan');
      expect(WeatherModel.conditionForCode(95), 'Hujan Petir');
    });
  });

  test('builds a live reading from Open-Meteo current values', () {
    final weather = WeatherModel.fromOpenMeteo(
      city: 'Bandung',
      current: {
        'temperature_2m': 27.6,
        'relative_humidity_2m': 74,
        'weather_code': 3,
        'wind_speed_10m': 8.4,
        'time': '2026-11-06T11:30',
      },
    );

    expect(weather.city, 'Bandung');
    expect(weather.temperature, 28);
    expect(weather.condition, 'Berawan');
    expect(weather.humidity, 74);
    expect(weather.windSpeed, 8);
    expect(weather.isLive, isTrue);
    expect(weather.observedAt, DateTime(2026, 11, 6, 11, 30));
  });
}
