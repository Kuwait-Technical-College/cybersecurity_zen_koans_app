import 'package:flutter/material.dart';

import 'ui/theme/theme.dart';
import 'ui/zen_koan_screen.dart';

void main() {
  runApp(const CybersecurityZenKoansApp());
}

class CybersecurityZenKoansApp extends StatelessWidget {
  const CybersecurityZenKoansApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cybersecurity Zen Koans',
      debugShowCheckedModeBanner: false,
      theme: zenLightTheme(),
      darkTheme: zenDarkTheme(),
      themeMode: ThemeMode.system,
      home: const ZenKoanScreen(),
    );
  }
}
