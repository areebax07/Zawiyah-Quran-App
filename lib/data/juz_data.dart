class JuzData {
  static const List<Map<String, dynamic>> juzList = [
    {"number": 1, "englishName": "Alif-laam-meem", "arabicName": "الم"},
    {"number": 2, "englishName": "Sayaqūlu", "arabicName": "سَيَقُولُ"},
    {"number": 3, "englishName": "Tilka 'r-Rusulu", "arabicName": "تِلْكَ الرُّسُلُ"},
    {"number": 4, "englishName": "Lan Tana Loo", "arabicName": "لَنْ تَنَالُوا"},
    {"number": 5, "englishName": "Wal Mohsanat", "arabicName": "وَالْمُحْصَنَاتُ"},
    {"number": 6, "englishName": "La Yuhibbullah", "arabicName": "لَا يُحِبُّ"},
    {"number": 7, "englishName": "Wa Iza Samiu", "arabicName": "وَإِذَا سَمِعُوا"},
    {"number": 8, "englishName": "Wa Lau Annana", "arabicName": "وَلَوْ أَنَّنَا"},
    {"number": 9, "englishName": "Qal Al-Mala'u", "arabicName": "قَالَ الْمَلَأُ"},
    {"number": 10, "englishName": "Wa A'lamu", "arabicName": "وَاعْلَمُوا"},
    {"number": 11, "englishName": "Yataziroon", "arabicName": "يَعْتَذِرُونَ"},
    {"number": 12, "englishName": "Wa Ma Min Da'abat", "arabicName": "وَمَا مِنْ دَابَّةٍ"},
    {"number": 13, "englishName": "Wa Ma Ubrioo", "arabicName": "وَمَا أُبَرِّئُ"},
    {"number": 14, "englishName": "Rubama", "arabicName": "رُبَمَا"},
    {"number": 15, "englishName": "Subhanallazi", "arabicName": "سُبْحَانَ الَّذِي"},
    {"number": 16, "englishName": "Qal Alam", "arabicName": "قَالَ أَلَمْ"},
    {"number": 17, "englishName": "Aqtarabo", "arabicName": "اقْتَرَبَ"},
    {"number": 18, "englishName": "Qadd Aflaha", "arabicName": "قَدْ أَفْلَحَ"},
    {"number": 19, "englishName": "Wa Qalallazina", "arabicName": "وَقَالَ الَّذِينَ"},
    {"number": 20, "englishName": "A'man Khalaq", "arabicName": "أَمَّنْ خَلَقَ"},
    {"number": 21, "englishName": "Utlu Ma Oohi", "arabicName": "اتْلُ مَا أُوحِيَ"},
    {"number": 22, "englishName": "Wa-man Yaqnut", "arabicName": "وَمَنْ يَقْنُتْ"},
    {"number": 23, "englishName": "Wa Mali", "arabicName": "وَمَا لِيَ"},
    {"number": 24, "englishName": "Faman Azlam", "arabicName": "فَمَنْ أَظْلَمُ"},
    {"number": 25, "englishName": "Elahe Yuruddo", "arabicName": "إِلَيْهِ يُرَدُّ"},
    {"number": 26, "englishName": "Ha'a Meem", "arabicName": "حم"},
    {"number": 27, "englishName": "Qala Fama Khatbukum", "arabicName": "قَالَ فَمَا خَطْبُكُمْ"},
    {"number": 28, "englishName": "Qadd Sami Allah", "arabicName": "قَدْ سَمِعَ"},
    {"number": 29, "englishName": "Tabarakallazi", "arabicName": "تَبَارَكَ الَّذِي"},
    {"number": 30, "englishName": "Amma Yatasa'aloon", "arabicName": "عَمَّ يَتَسَاءَلُونَ"}
  ];

  static const Map<int, List<int>> juzToPages = {
    1: [1, 21], 2: [22, 41], 3: [42, 61], 4: [62, 81], 5: [82, 101],
    6: [102, 121], 7: [122, 141], 8: [142, 161], 9: [162, 181], 10: [182, 201],
    11: [202, 221], 12: [222, 241], 13: [242, 261], 14: [262, 281], 15: [282, 301],
    16: [302, 321], 17: [322, 341], 18: [342, 361], 19: [362, 381], 20: [382, 401],
    21: [402, 421], 22: [422, 441], 23: [442, 461], 24: [462, 481], 25: [482, 501],
    26: [502, 521], 27: [522, 541], 28: [542, 561], 29: [562, 581], 30: [582, 604],
  };

  // Helper function to get Juz information from a page number
  static Map<String, dynamic> getJuzInfoFromPage(int pageNumber) {
    for (var entry in juzToPages.entries) {
      if (pageNumber >= entry.value[0] && pageNumber <= entry.value[1]) {
        final juzDetail = juzList.firstWhere((j) => j['number'] == entry.key);
        return {
          'juzNumber': entry.key,
          'englishName': juzDetail['englishName'],
        };
      }
    }
    return {'juzNumber': 0, 'englishName': 'Unknown'};
  }
}
