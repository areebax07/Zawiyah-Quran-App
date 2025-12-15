import 'package:flutter/material.dart';

class QuranImageScreen extends StatefulWidget {
  final int initialPageNumber;

  const QuranImageScreen({Key? key, required this.initialPageNumber}) : super(key: key);

  @override
  _QuranImageScreenState createState() => _QuranImageScreenState();
}

class _QuranImageScreenState extends State<QuranImageScreen> {
  late PageController _pageController;
  late int _currentPage;
  final int _totalPages = 604;
  final TransformationController _transformationController = TransformationController();

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPageNumber.clamp(1, _totalPages);
    _pageController = PageController(initialPage: _currentPage - 1);
  }

  void _onPageChanged(int newPageIndex) {
    setState(() {
      _currentPage = newPageIndex + 1;
    });
    _transformationController.value = Matrix4.identity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Quran'),
        backgroundColor: const Color(0xFF5C0632),
        foregroundColor: Colors.white,
      ),
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        itemCount: _totalPages,
        itemBuilder: (context, index) {
          final pageNumber = index + 1;
          final imagePath = 'assets/mushaf/${pageNumber.toString().padLeft(3, '0')}.png';

          return InteractiveViewer(
            transformationController: _transformationController,
            panEnabled: false,
            minScale: 0.5,
            maxScale: 3.0,
            child: Center(
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, size: 50, color: Colors.grey),
                    const SizedBox(height: 16),
                    const Text("Page image not found in assets"),
                    const SizedBox(height: 8),
                    Text("Page $pageNumber"),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF5C0632),
        child: SizedBox(
          height: 50.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'Page $_currentPage of $_totalPages',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              const Row(
                children: [
                  Icon(Icons.swipe, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Swipe to turn page',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
