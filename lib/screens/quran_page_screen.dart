import 'dart:async';
import 'package:flutter/material.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:zawiyah/data/juz_data.dart';
import '../data/quran_pages.dart';

class QuranPageScreen extends StatefulWidget {
  final int? surahNumber;
  final int? startingPage;

  const QuranPageScreen({Key? key, this.surahNumber, this.startingPage}) : super(key: key);

  @override
  _QuranPageScreenState createState() => _QuranPageScreenState();
}

class _QuranPageScreenState extends State<QuranPageScreen> {
  late PageController _pageController;
  late int _currentPage;
  final int _totalPagesInMushaf = 604;
  late Map<String, dynamic> _currentSurahInfo;
  late Map<String, dynamic> _currentJuzInfo; // Added to hold Juz info

  bool _isDarkMode = false;
  int _overlayColorIndex = 0;
  final List<Color> _overlayColors = [
    Colors.transparent,
    const Color(0xFFFF9800),
    const Color(0xFFE91E63),
    const Color(0xFF64B5F6),
    const Color(0xFF81C784),
  ];
  int _fontColorIndex = 0;
  final List<Color> _fontColors = [Colors.black, Colors.white, const Color(0xFF006400), const Color(0xFF00008B)];

  bool _isBrightnessSliderVisible = false;
  double _currentBrightness = 1.0;

  @override
  void initState() {
    super.initState();
    if (widget.startingPage != null) {
      _currentPage = widget.startingPage!;
    } else if (widget.surahNumber != null) {
      // --- ERROR FIX: Use the correct map name ---
      _currentPage = QuranData.surahToPageRange[widget.surahNumber]![0];
    } else {
      _currentPage = 1;
    }

    _currentPage = _currentPage.clamp(1, _totalPagesInMushaf);
    _pageController = PageController(initialPage: _totalPagesInMushaf - _currentPage);
    _updatePageInfo(_currentPage);
    _initializeBrightness();
  }

  void _updatePageInfo(int page) {
    _currentSurahInfo = QuranData.getSurahInfoFromPage(page);
    _currentJuzInfo = JuzData.getJuzInfoFromPage(page);
  }

  Future<void> _initializeBrightness() async {
    try {
      _currentBrightness = await ScreenBrightness().current;
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  void _onPageChanged(int newPageIndex) {
    setState(() {
      _currentPage = _totalPagesInMushaf - newPageIndex;
      _updatePageInfo(_currentPage);
    });
  }

  void _toggleDarkMode() {
    setState(() {
      _isDarkMode = !_isDarkMode;
      _fontColorIndex = 0;
    });
  }

  void _cycleOverlayColor() {
    setState(() {
      _overlayColorIndex = (_overlayColorIndex + 1) % _overlayColors.length;
    });
  }

  void _cycleFontColor() {
    setState(() {
      _fontColorIndex = (_fontColorIndex + 1) % _fontColors.length;
    });
  }

  void _showBrightnessSlider(bool show) {
    setState(() {
      _isBrightnessSliderVisible = show;
    });
  }

  void _setBrightness(double value) {
    ScreenBrightness().setScreenBrightness(value);
    setState(() {
      _currentBrightness = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isSpecialPage = _currentPage == 1 || _currentPage == 2;
    final Color baseBackgroundColor = _isDarkMode ? const Color(0xFF121212) : Colors.white;
    final Color currentOverlayColor = _overlayColors[_overlayColorIndex];

    Color currentFontColor;
    if (_fontColorIndex == 0) {
      currentFontColor = _isDarkMode ? Colors.white : Colors.black;
    } else {
      currentFontColor = _fontColors[_fontColorIndex];
    }

    // --- ERROR FIX: Use the correct key for the surah name ---
    final appBarTitle = "${_currentJuzInfo['englishName']} - ${_currentSurahInfo['englishName']}";

    return Scaffold(
      backgroundColor: baseBackgroundColor,
      appBar: AppBar(
        title: Text(appBarTitle),
        backgroundColor: const Color(0xFF8B46D7),
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          PageView.builder(
            reverse: true,
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: _totalPagesInMushaf,
            itemBuilder: (context, index) {
              final pageNumber = _totalPagesInMushaf - index;
              final imagePath = 'assets/mushaf/${pageNumber.toString().padLeft(3, '0')}.png';

              return Center(
                child: Padding(
                  padding: isSpecialPage ? const EdgeInsets.all(24.0) : const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: baseBackgroundColor,
                      border: Border.all(color: _isDarkMode ? Colors.white70 : Colors.black87, width: 2),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.25), spreadRadius: 1, blurRadius: 10, offset: const Offset(0, 4))],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: InteractiveViewer(
                      panEnabled: false,
                      minScale: 0.5,
                      maxScale: 3.0,
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(currentFontColor, BlendMode.srcIn),
                        child: Image.asset(imagePath, fit: BoxFit.contain, errorBuilder: (c, e, s) => Center(child: Text('Page $pageNumber not found'))),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          IgnorePointer(
            child: Container(
              color: currentOverlayColor.withOpacity(0.2),
            ),
          ),
          if (_isBrightnessSliderVisible)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Slider(value: _currentBrightness, onChanged: _setBrightness, min: 0.1, max: 1.0),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    ElevatedButton(onPressed: () => _showBrightnessSlider(false), child: const Text('Apply')),
                    const SizedBox(width: 20),
                    ElevatedButton(onPressed: () { _setBrightness(1.0); _showBrightnessSlider(false); }, child: const Text('Cancel')),
                  ])
                ]),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF8A46D6),
        child: SizedBox(
          height: 60.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildBottomBarButton(Icons.bookmark_border, "Bookmark", () {}),
              _buildBottomBarButton(Icons.layers_outlined, "Overlay", _cycleOverlayColor),
              _buildBottomBarButton(Icons.text_format, "Font Color", _cycleFontColor),
              _buildBottomBarButton(_isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined, "Night Mode", _toggleDarkMode),
              _buildBottomBarButton(Icons.brightness_6_outlined, "Brightness", () => _showBrightnessSlider(true)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBarButton(IconData icon, String label, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(30),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}
