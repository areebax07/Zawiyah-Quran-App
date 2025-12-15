import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zawiyah/data/quran_pages.dart';
import 'package:zawiyah/providers/quran_provider.dart';
import 'package:zawiyah/providers/settings_provider.dart';
import 'package:zawiyah/screens/quran_page_screen.dart';
import 'dart:math' as math;

// FIX: Converted to StatefulWidget to handle search
class JuzListScreen extends StatefulWidget {
  const JuzListScreen({Key? key}) : super(key: key);

  @override
  State<JuzListScreen> createState() => _JuzListScreenState();
}

class _JuzListScreenState extends State<JuzListScreen> {
  bool _isSearching = false;
  List<int> _filteredJuz = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize with all 30 Juz
    _filteredJuz = List.generate(30, (i) => i + 1);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      if (query.isEmpty) {
        _filteredJuz = List.generate(30, (i) => i + 1);
      } else {
        _filteredJuz = List.generate(30, (i) => i + 1).where((juzNumber) {
          final juzName = "juz $juzNumber";
          final juzInfo = QuranData.getJuzInfo(juzNumber);
          final surahName = (juzInfo['surahName'] as String).toLowerCase();
          
          return juzName.contains(query) || surahName.contains(query) || juzNumber.toString().contains(query);
        }).toList();
      }
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      // Clear search and restore full list when closing search
      if (!_isSearching) {
        _searchController.clear();
        _filteredJuz = List.generate(30, (i) => i + 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        final isDarkMode = settings.isDarkMode;
        final bgColor = isDarkMode ? const Color(0xFF0D0216) : Colors.grey[100];
        final textColor = isDarkMode ? Colors.white : Colors.black87;
        final purpleColor = const Color(0xFF863ED5);

        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            backgroundColor: bgColor,
            foregroundColor: textColor,
            elevation: 0,
            // FIX: Implement search UI toggle
            title: _isSearching
                ? TextField(
                    controller: _searchController,
                    autofocus: true,
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      hintText: 'Search Para...',
                      hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
                      border: InputBorder.none,
                    ),
                  )
                : Text('Para', style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
            actions: [
              IconButton(
                icon: Icon(_isSearching ? Icons.close : Icons.search, color: textColor),
                onPressed: _toggleSearch,
              ),
            ],
          ),
          body: CustomScrollView(
            slivers: [
              // FIX: Hide header and card when searching
              if (!_isSearching)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // FIX: Corrected greeting text
                        Text('“The best of those amongst you is the one who learns the Qur’an and then teaches it to others.”', style: TextStyle(color: textColor.withOpacity(0.7))),
                        const SizedBox(height: 4),
                        Text('Zawiyah', style: TextStyle(color: textColor, fontSize: 28, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 20),
                        _buildLastReadCard(context),
                      ],
                    ),
                  ),
                ),
              // FIX: Use filtered list for search results
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final juzNumber = _filteredJuz[index];
                    final juzInfo = QuranData.getJuzInfo(juzNumber);
                    final pageNumber = QuranData.juzToPageRange[juzNumber]![0];
                    final juzName = "Juz $juzNumber";

                    return Column(
                      children: [
                        ListTile(
                          leading: _buildNumberShape(juzNumber, purpleColor, textColor),
                          title: Text(juzName, style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
                          subtitle: Text("Starts at: ${juzInfo['surahName']} Ayah ${juzInfo['ayahNumber']}", style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 12)),
                          trailing: Icon(Icons.arrow_forward_ios, color: textColor.withOpacity(0.5), size: 16),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => QuranPageScreen(startingPage: pageNumber)));
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Divider(color: isDarkMode ? Colors.white24 : Colors.grey[300]),
                        )
                      ],
                    );
                  },
                  childCount: _filteredJuz.length,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLastReadCard(BuildContext context) {
    final quranProvider = context.watch<QuranProvider>();
    final lastRead = quranProvider.lastReadSurah;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFA060E2), Color(0xFF863ED5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: const Color(0xFF863ED5).withOpacity(0.3), spreadRadius: 2, blurRadius: 15)]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Last Read", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Text(
                lastRead?['englishName'] as String? ?? "Al-Fatihah",
                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                "Ayah No: ${lastRead?['ayahNumber'] ?? 1}",
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
          // FIX: Changed image to be consistent
          Image.asset('assets/images/pqu.png', width: 90, height: 90, fit: BoxFit.contain, errorBuilder: (c, o, s) => const SizedBox(width: 90, height: 90)),
        ],
      ),
    );
  }

  Widget _buildNumberShape(int number, Color color, Color textColor) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CustomPaint(size: const Size(40, 40), painter: NumberShapePainter(color: color)),
        Text(number.toString(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }
}

class NumberShapePainter extends CustomPainter {
  final Color color;
  NumberShapePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();
    const angle = (math.pi * 2) / 8;
    const outerRadius = 20.0;
    const innerRadius = 18.0;

    final center = Offset(size.width / 2, size.height / 2);

    for (int i = 0; i < 8; i++) {
      final p1 = Offset(math.cos(angle * i) * outerRadius, math.sin(angle * i) * outerRadius);
      final p2 = Offset(math.cos(angle * (i + 0.5)) * innerRadius, math.sin(angle * (i + 0.5)) * innerRadius);

      if (i == 0) path.moveTo(p1.dx + center.dx, p1.dy + center.dy);
      path.lineTo(p1.dx + center.dx, p1.dy + center.dy);
      path.lineTo(p2.dx + center.dx, p2.dy + center.dy);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
