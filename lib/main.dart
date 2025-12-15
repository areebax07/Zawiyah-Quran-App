import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:zawiyah/providers/quran_provider.dart';
import 'package:zawiyah/providers/settings_provider.dart';
import 'package:zawiyah/screens/auth_gate.dart';
import 'package:zawiyah/screens/language_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => QuranProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, child) {
          return MaterialApp(
            title: 'Zawiyah',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.purple,
              brightness: Brightness.light,
              scaffoldBackgroundColor: Colors.grey[100],
              fontFamily: 'Poppins',
            ),
            darkTheme: ThemeData(
              primarySwatch: Colors.purple,
              brightness: Brightness.dark,
              scaffoldBackgroundColor: const Color(0xFF0D0216),
              fontFamily: 'Poppins',
            ),
            themeMode: settings.themeMode,
            home: const AuthGate(),
            routes: {
              '/language': (context) => const LanguageScreen(),
            },
            builder: (context, child) {
              final scale = settings.fontScale;
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: scale),
                child: child!,
              );
            },
          );
        },
      ),
    );
  }
}
