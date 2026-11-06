import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AtmosApp());
}

class AtmosApp extends StatelessWidget {
  const AtmosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ATMOS Weather',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const HomeScreen(),
    );
  }
}