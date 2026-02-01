import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../services/api_service.dart';
import 'surah_audio_player_screen.dart';

class SurahAudioListScreen extends StatefulWidget {
  const SurahAudioListScreen({Key? key}) : super(key: key);

  @override
  _SurahAudioListScreenState createState() => _SurahAudioListScreenState();
}

class _SurahAudioListScreenState extends State<SurahAudioListScreen> {
  late Future<List<dynamic>> _surahsFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _surahsFuture = _apiService.getSurahList();
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final isDarkMode = settings.isDarkMode;
    final purpleColor = const Color(0xFF863ED5);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quran Audio'),
        backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : purpleColor,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _surahsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Surahs found.'));
          }

          final surahs = snapshot.data!;

          return ListView.builder(
            itemCount: surahs.length,
            itemBuilder: (context, index) {
              final surah = surahs[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: purpleColor,
                    child: Text(
                      surah['number'].toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(surah['name'] ?? 'Unknown'),
                  subtitle: Text('${surah['englishName']} - ${surah['revelationType']}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SurahAudioPlayerScreen(
                          surahNumber: surah['number'],
                          surahName: surah['englishName'] ?? 'Unknown',
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
