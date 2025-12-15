import 'package:flutter/material.dart';
import 'screens/homescreen.dart';
import 'screens/surah_list_screen.dart';
import 'screens/language_screen.dart';

// We don't need to import or route the QuranImageScreen here because
// we are navigating to it directly, not by a named route.

// Placeholder screens for now
class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text("$title Screen - Coming Soon")),
    );
  }
}

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/': (_) => const HomeScreen(),
    '/surah_list': (_) => const SurahListScreen(),
    '/language': (_) => const LanguageScreen(),
    // The old'/surah_detail' route has been removed.
  };
}
