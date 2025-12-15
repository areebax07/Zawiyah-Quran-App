import 'package:flutter/material.dart';
import 'package:screen_brightness/screen_brightness.dart';

class AsmaUlHusnaScreen extends StatefulWidget {
  const AsmaUlHusnaScreen({Key? key}) : super(key: key);

  @override
  _AsmaUlHusnaScreenState createState() => _AsmaUlHusnaScreenState();
}

class _AsmaUlHusnaScreenState extends State<AsmaUlHusnaScreen> {
  late PageController _pageController;
  late int _currentPage;
  final int _totalPages = 5;

  bool _isDarkMode = false;
  int _overlayColorIndex = 0;
  final List<Color> _overlayColors = [
    Colors.transparent,
    const Color(0xFFFF9800), // Orange
    const Color(0xFFE91E63), // Pink
    const Color(0xFF64B5F6), // Light Blue
    const Color(0xFF81C784), // Light Green
  ];
  int _fontColorIndex = 0;
  final List<Color> _fontColors = [
    Colors.black, // Default for Light Mode
    Colors.white, // Default for Dark Mode
    const Color(0xFF006400), // Dark Green
    const Color(0xFF00008B), // Dark Blue
  ];

  bool _isBrightnessSliderVisible = false;
  double _currentBrightness = 1.0;

  @override
  void initState() {
    super.initState();
    _currentPage = 1;
    // --- FIX: Simplified initialPage calculation ---
    _pageController = PageController(initialPage: _currentPage - 1);
    _initializeBrightness();
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
      // --- FIX: Simplified page update logic ---
      _currentPage = newPageIndex + 1;
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
    final Color baseBackgroundColor = _isDarkMode ? const Color(0xFF121212) : Colors.white;
    final Color currentOverlayColor = _overlayColors[_overlayColorIndex];

    Color currentFontColor;
    if (_fontColorIndex == 0) {
      currentFontColor = _isDarkMode ? Colors.white : Colors.black;
    } else {
      currentFontColor = _fontColors[_fontColorIndex];
    }

    return Scaffold(
      backgroundColor: baseBackgroundColor,
      appBar: AppBar(
        title: Text("Asma ul Husna - Page $_currentPage"),
        backgroundColor: const Color(0xFF8B46D7),
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          // --- FIX: Added Directionality for correct RTL swipe gesture ---
          Directionality(
            textDirection: TextDirection.rtl,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: _totalPages,
              itemBuilder: (context, index) {
                // --- FIX: Simplified page number calculation ---
                final pageNumber = index + 1;
                final imagePath = 'assets/99namesofAllah/page$pageNumber.png';

                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
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
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            ColorFiltered(
                              colorFilter: ColorFilter.mode(currentFontColor, BlendMode.srcIn),
                              child: Image.asset(imagePath, fit: BoxFit.contain, errorBuilder: (c, e, s) => Center(child: Text('Page $pageNumber not found'))),
                            ),
                            Container(color: currentOverlayColor.withOpacity(0.2)),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          IgnorePointer(
            child: Container(color: currentOverlayColor.withOpacity(0.2)),
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
