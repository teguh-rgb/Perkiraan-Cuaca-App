import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/weather_model.dart';
import '../services/weather_service.dart';
import '../theme/app_theme.dart';
import 'weather_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherService _weatherService = WeatherService();
  late final Future<List<WeatherModel>> _weatherFuture;

  @override
  void initState() {
    super.initState();
    _weatherFuture = _weatherService.fetchWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AtmosBackground(
        child: SafeArea(
          child: FutureBuilder<List<WeatherModel>>(
            future: _weatherFuture,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('Data cuaca tidak dapat dimuat: ${snapshot.error}'),
                );
              }
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(color: AppTheme.primary),
                );
              }
              final weather = snapshot.data!;
              final featured = weather.firstWhere(
                (item) => item.city == 'Bandung',
                orElse: () => weather.first,
              );
              final cities = weather.where((item) => item != featured).take(3).toList();
              return LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight - 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _Header(),
                        const SizedBox(height: 24),
                        Text(
                          'Selamat siang',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 30,
                            height: 1.1,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Langit ${featured.city} berawan, bawa jaket tipis hari ini.',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _FeaturedWeatherCard(
                          weather: featured,
                          onTap: () => _openDetails(context, featured),
                        ),
                        const SizedBox(height: 22),
                        Row(
                          children: [
                            Text(
                              'Kota Lainnya',
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '${cities.length} kota',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        SizedBox(
                          height: 200,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: cities.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 12),
                            itemBuilder: (context, index) => _CityWeatherCard(
                              weather: cities[index],
                              onTap: () => _openDetails(context, cities[index]),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _openDetails(BuildContext context, WeatherModel weather) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => WeatherDetailScreen(weather: weather),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    const weekdays = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
    ];
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFF66C7FF), Color(0xFF9D8EFF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primary.withOpacity(0.28),
                blurRadius: 18,
              ),
            ],
          ),
          child: const Icon(Icons.radar_rounded, color: Color(0xFF08101E), size: 25),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ATMOS',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 20,
                height: 1,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'WEATHER INTELLIGENCE',
              style: GoogleFonts.inter(
                fontSize: 8,
                letterSpacing: 1.4,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.12)),
          ),
          child: Text(
            '${weekdays[now.weekday - 1]}, ${now.day} ${months[now.month - 1]}',
            style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.07),
            border: Border.all(color: Colors.white.withOpacity(0.16)),
          ),
          child: const Icon(Icons.person_outline_rounded, size: 19),
        ),
      ],
    );
  }
}

class _FeaturedWeatherCard extends StatelessWidget {
  const _FeaturedWeatherCard({required this.weather, required this.onTap});

  final WeatherModel weather;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(32),
        onTap: onTap,
        child: Container(
          height: 312,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white.withOpacity(0.18)),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0x3BB9A8FF), Color(0x12FFFFFF), Color(0x080D18)],
            ),
            boxShadow: const [
              BoxShadow(color: Color(0x55000000), blurRadius: 36, offset: Offset(0, 20)),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              Positioned(
                right: -24,
                top: -14,
                width: 190,
                height: 178,
                child: Image.asset('assets/images/partly_sunny_cloud.png', fit: BoxFit.contain),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.white.withOpacity(0.15)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.location_on_rounded, size: 14, color: AppTheme.primary),
                        const SizedBox(width: 5),
                        Text(weather.city, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${weather.temperature}',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 82,
                          height: 0.95,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -3,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text('°C', style: GoogleFonts.spaceGrotesk(fontSize: 28, color: const Color(0xFFC8D2E2))),
                      ),
                    ],
                  ),
                  const SizedBox(height: 7),
                  Text(weather.condition, style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w500)),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(child: _MetricPill(icon: Icons.water_drop_outlined, label: 'Kelembapan', value: '${weather.humidity}%')),
                      const SizedBox(width: 10),
                      Expanded(child: _MetricPill(icon: Icons.air_rounded, label: 'Kecepatan Angin', value: '${weather.windSpeed} km/h')),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetricPill extends StatelessWidget {
  const _MetricPill({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 9),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.055),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.16),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, size: 16, color: AppTheme.primary),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.inter(fontSize: 9, color: AppTheme.textSecondary)),
                const SizedBox(height: 2),
                Text(value, maxLines: 1, style: GoogleFonts.spaceGrotesk(fontSize: 14, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CityWeatherCard extends StatelessWidget {
  const _CityWeatherCard({required this.weather, required this.onTap});

  final WeatherModel weather;
  final VoidCallback onTap;

  bool get isRainy => weather.condition.toLowerCase().contains('hujan');

  @override
  Widget build(BuildContext context) {
    final accent = isRainy ? AppTheme.primary : AppTheme.amber;
    return SizedBox(
      width: 107,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: accent.withOpacity(0.32)),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [accent.withOpacity(0.17), Colors.white.withOpacity(0.035), const Color(0x14111B2B)],
              ),
              boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 24, offset: Offset(0, 12))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 84,
                  width: double.infinity,
                  child: Image.asset(
                    isRainy ? 'assets/images/rain_cloud.png' : 'assets/images/windy_sun.png',
                    fit: BoxFit.contain,
                  ),
                ),
                Text(weather.city, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600)),
                Text('${weather.temperature}°C', style: GoogleFonts.spaceGrotesk(fontSize: 28, height: 1, fontWeight: FontWeight.bold)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: accent.withOpacity(0.17), borderRadius: BorderRadius.circular(11)),
                  child: Text(weather.condition, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.inter(fontSize: 10, color: accent, fontWeight: FontWeight.w500)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AtmosBackground extends StatelessWidget {
  const AtmosBackground({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF15192D), Color(0xFF080D18), Color(0xFF101A29)],
          stops: [0, 0.48, 1],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -160,
            left: -100,
            child: _Glow(size: 430, color: const Color(0xFF9C87FF).withOpacity(0.15)),
          ),
          Positioned(
            top: 10,
            right: -170,
            child: _Glow(size: 360, color: const Color(0xFFFFC76B).withOpacity(0.08)),
          ),
          Positioned(
            bottom: 40,
            left: -190,
            child: _Glow(size: 420, color: const Color(0xFF438CFF).withOpacity(0.10)),
          ),
          Positioned(
            top: -130,
            right: -130,
            child: Container(
              width: 390,
              height: 390,
              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white.withOpacity(0.035))),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [color, color.withOpacity(0)]),
        ),
      ),
    );
  }
}