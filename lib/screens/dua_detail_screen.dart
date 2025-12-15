import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zawiyah/providers/settings_provider.dart';

class DuaDetailScreen extends StatelessWidget {
  final Map<String, dynamic> dua;

  const DuaDetailScreen({Key? key, required this.dua}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        final isDarkMode = settings.isDarkMode;
        final bgColor = isDarkMode ? const Color(0xFF0D0216) : Colors.grey[100];
        final cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
        final textColor = isDarkMode ? Colors.white : Colors.black87;
        final subtleTextColor = isDarkMode ? Colors.white70 : Colors.black54;
        final purpleColor = const Color(0xFF863ED5);

        final title = dua['title'] as String? ?? 'Dua';
        final arabicText = dua['arabic_text'] as String? ?? 'No Arabic text available.';
        final translation = dua['translation'] as String? ?? 'No translation available.';
        final reference = dua['reference'] as String? ?? 'No reference available.';

        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 18)),
            backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : purpleColor,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  BoxShadow(
                    color: isDarkMode ? Colors.black.withOpacity(0.2) : Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 8,
                  )
                ]
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    arabicText,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 26.0,
                      height: 1.8,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Divider(color: subtleTextColor.withOpacity(0.2)),
                  const SizedBox(height: 10),

                  Text(
                    'Translation:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: purpleColor,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    translation,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontStyle: FontStyle.italic,
                      height: 1.5,
                      color: subtleTextColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                   Divider(color: subtleTextColor.withOpacity(0.2)),
                  const SizedBox(height: 10),

                  Text(
                    'Reference:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: purpleColor,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    reference,
                    style: TextStyle(fontSize: 14.0, color: subtleTextColor),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
