class TasbihItem {
  String arabicText;
  String transliteration;
  int count;
  int targetCount;
  int totalCount;
  int cumulativeCount; // Added for the new screen

  TasbihItem({
    required this.arabicText,
    required this.transliteration,
    this.count = 0,
    this.targetCount = 33,
    this.totalCount = 0,
    this.cumulativeCount = 0, // Initialize the new field
  });
}
