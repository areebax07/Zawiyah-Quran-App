import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'package:hive/hive.dart';

class QuranProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  Box? _quranBox;

  List _surahList = [];
  bool _loading = false;

  Map<String, dynamic>? _lastReadSurah;

  List get surahList => _surahList;
  bool get loading => _loading;
  Map<String, dynamic>? get lastReadSurah => _lastReadSurah;

  QuranProvider() {
    _openBox();
  }

  Future<void> _openBox() async {
    _quranBox = await Hive.openBox('quranData');
    _surahList = _quranBox?.get('surahList', defaultValue: []);
    notifyListeners();
  }

  Future<void> fetchSurahList() async {
    if (_loading || _surahList.isNotEmpty) return;

    _loading = true;
    notifyListeners();

    try {
      _surahList = await _apiService.getSurahList();
      await _quranBox?.put('surahList', _surahList);
    } catch (e) {
      print("Error fetching surah list: $e");
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // --- THIS IS THE NEW METHOD THAT WAS MISSING ---
  Future<List<dynamic>> getSurah(int surahNumber) async {
    // Define a key to store the surah in the database
    final String key = 'surah_$surahNumber';

    // 1. Try to get the data from the local cache first
    final cachedSurah = _quranBox?.get(key);
    if (cachedSurah != null) {
      print("Loading Surah $surahNumber from cache");
      return cachedSurah as List<dynamic>;
    }

    // 2. If not in cache, fetch from the API
    print("Fetching Surah $surahNumber from API");
    try {
      final surahData = await _apiService.getSurah(surahNumber);
      // The API returns a map, we need the 'ayahs' list from it.
      final ayahs = surahData['ayahs'] as List<dynamic>? ?? [];

      // 3. Save the fetched data to the cache for next time
      await _quranBox?.put(key, ayahs);
      return ayahs;
    } catch (e) {
      print("Error fetching surah $surahNumber: $e");
      return []; // Return an empty list on error
    }
  }

  void setLastReadSurah(Map<String, dynamic> surahData) {
    _lastReadSurah = surahData;
    notifyListeners();
  }
}
