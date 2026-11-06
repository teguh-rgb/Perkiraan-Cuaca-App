import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/weather_model.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';

class WeatherDetailScreen extends StatelessWidget {
  const WeatherDetailScreen({required this.weather, super.key});

  final WeatherModel weather;

  @override
  Widget build(BuildContext context) {
    final image = weatherImageFor(weather);
    return Scaffold(
      body: AtmosBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 6, 24, 20),
            child: Column(
              children: [
                Row(
                  children: [
                    _CircleButton(icon: Icons.chevron_left_rounded, onPressed: () => Navigator.of(context).pop()),
                    const Spacer(),
                    Column(
                      children: [
                        Text(weather.city, style: GoogleFonts.spaceGrotesk(fontSize: 19, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(Icons.location_on_rounded, size: 12, color: Color(0xFFB5A4FF)),
                            const SizedBox(width: 3),
                            Text(_regionFor(weather.city), style: GoogleFonts.inter(fontSize: 11, color: AppTheme.textSecondary)),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                    const SizedBox(width: 44),
                  ],
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 310,
                              height: 240,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [Colors.white.withOpacity(0.10), Colors.transparent],
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 20,
                              child: Container(
                                width: 200,
                                height: 20,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  boxShadow: [BoxShadow(color: Colors.white.withOpacity(0.13), blurRadius: 30)],
                                ),
                              ),
                            ),
                            Hero(
                              tag: 'weather-art-${weather.city}',
                              child: Image.asset(
                                image,
                                fit: BoxFit.contain,
                                width: 300,
                                height: 250,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 122,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${weather.temperature}',
                              style: GoogleFonts.spaceGrotesk(fontSize: 92, height: 1, fontWeight: FontWeight.bold, letterSpacing: -4),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 14),
                              child: Text('°C', style: GoogleFonts.spaceGrotesk(fontSize: 34, color: const Color(0xFFC8D2E2))),
                            ),
                          ],
                        ),
                      ),
                      Text(weather.condition, style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 4),
                      Text('${weather.city}, ${_regionFor(weather.city)}', style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary)),
                      const SizedBox(height: 14),
                      SizedBox(
                        height: 214,
                        child: Row(
                          children: [
                            Expanded(child: _HumidityCard(value: weather.humidity)),
                            const SizedBox(width: 12),
                            Expanded(child: _WindCard(value: weather.windSpeed)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _regionFor(String city) {
    return switch (city) {
      'Bandung' => 'Jawa Barat',
      'Jakarta' => 'DKI Jakarta',
      'Bogor' => 'Jawa Barat',
      'Surabaya' => 'Jawa Timur',
      _ => 'Indonesia',
    };
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton.filledTonal(
      onPressed: onPressed,
      icon: Icon(icon, size: 24),
      style: IconButton.styleFrom(
        fixedSize: const Size(44, 44),
        backgroundColor: Colors.white.withOpacity(0.09),
        foregroundColor: AppTheme.textPrimary,
        side: BorderSide(color: Colors.white.withOpacity(0.15)),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.title, required this.icon, required this.child});

  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withOpacity(0.14)),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0x292D3D51), Color(0x0CFFFFFF)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(color: AppTheme.primary.withOpacity(0.16), shape: BoxShape.circle),
                child: Icon(icon, size: 15, color: AppTheme.primary),
              ),
              const SizedBox(width: 8),
              Expanded(child: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.inter(fontSize: 11, color: AppTheme.textSecondary))),
            ],
          ),
          Expanded(child: Center(child: child)),
          Center(child: Text(title == 'Kelembapan' ? 'Kelembapan relatif' : 'Skala 0–40 km/h', style: GoogleFonts.inter(fontSize: 10, color: AppTheme.textSecondary))),
        ],
      ),
    );
  }
}

class _HumidityCard extends StatelessWidget {
  const _HumidityCard({required this.value});

  final int value;

  @override
  Widget build(BuildContext context) {
    return _MetricCard(
      title: 'Kelembapan',
      icon: Icons.water_drop_outlined,
      child: SizedBox(
        width: 110,
        height: 110,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 110,
              height: 110,
              child: CircularProgressIndicator(
                value: value.clamp(0, 100) / 100,
                strokeWidth: 8,
                backgroundColor: Colors.white.withOpacity(0.09),
                color: const Color(0xFF92A7FF),
              ),
            ),
            Text('$value%', style: GoogleFonts.spaceGrotesk(fontSize: 28, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class _WindCard extends StatelessWidget {
  const _WindCard({required this.value});

  final int value;

  @override
  Widget build(BuildContext context) {
    return _MetricCard(
      title: 'Kecepatan Angin',
      icon: Icons.air_rounded,
      child: SizedBox(
        width: 118,
        height: 100,
        child: CustomPaint(
          painter: _WindGaugePainter(value: value),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('$value', style: GoogleFonts.spaceGrotesk(fontSize: 28, fontWeight: FontWeight.bold)),
              Text('km/h', style: GoogleFonts.inter(fontSize: 10, color: AppTheme.textSecondary)),
              const SizedBox(height: 2),
            ],
          ),
        ),
      ),
    );
  }
}

class _WindGaugePainter extends CustomPainter {
  const _WindGaugePainter({required this.value});

  final int value;

  @override
  void paint(Canvas canvas, Size size) {
    const start = 3.141592653589793;
    const sweep = 3.141592653589793;
    final rect = Rect.fromLTWH(8, 2, size.width - 16, size.height * 1.55);
    final track = Paint()
      ..color = Colors.white.withOpacity(0.09)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 9
      ..strokeCap = StrokeCap.round;
    final active = Paint()
      ..shader = const LinearGradient(colors: [Color(0xFF74D2FF), Color(0xFF9EA8FF)]).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 9
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, start, sweep, false, track);
    canvas.drawArc(rect, start, sweep * (value.clamp(0, 40) / 40), false, active);
    final labels = TextPainter(
      text: TextSpan(text: '0                                   40', style: TextStyle(color: AppTheme.textSecondary, fontSize: 9)),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout(maxWidth: size.width);
    labels.paint(canvas, Offset(0, size.height - labels.height));
  }

  @override
  bool shouldRepaint(covariant _WindGaugePainter oldDelegate) => oldDelegate.value != value;
}