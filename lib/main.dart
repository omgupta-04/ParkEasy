import 'package:flutter/material.dart';
import 'app.dart';
import 'package:showcaseview/showcaseview.dart';


void main() {
  runApp(ParkEasyRoot());
}

class ParkEasyRoot extends StatelessWidget {
  // Using ValueNotifier for theme switching
  static final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.system);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode mode, __) {
        return MyApp(themeMode: mode);
      },
    );
  }
}