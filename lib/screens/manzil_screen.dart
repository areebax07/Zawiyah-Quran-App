import 'package:flutter/material.dart';

class ManzilScreen extends StatefulWidget {
  const ManzilScreen({Key? key}) : super(key: key);

  @override
  _ManzilScreenState createState() => _ManzilScreenState();
}

class _ManzilScreenState extends State<ManzilScreen> {
  final int _totalPages = 15;
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int newPage) {
    setState(() {
      _currentPage = newPage;
    });
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFE9EC), // Light Blue Shade
      appBar: AppBar(
        title: const Text('Manzil'),
        backgroundColor: const Color(0xFF8B46D7), // Darker Blue Shade
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: _totalPages,
            itemBuilder: (context, index) {
              final pageNumber = index + 1;
              final imagePath = 'assets/manzil/mi$pageNumber.png';
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: InteractiveViewer(
                  panEnabled: true, // Allows panning
                  minScale: 1.0,
                  maxScale: 4.0, // Adjust max zoom level if needed
                  child: Center(
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.contain,
                      errorBuilder: (c, e, s) => Center(
                          child: Text(
                        'Image $pageNumber not found',
                        style: const TextStyle(color: Colors.red),
                      )),
                    ),
                  ),
                ),
              );
            },
          ),
          // Navigation Arrows
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.black.withOpacity(0.5),
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: _currentPage > 0 ? Colors.white : Colors.white.withOpacity(0.3)),
                    onPressed: _currentPage > 0 ? _previousPage : null,
                  ),
                  Text(
                    'Page ${_currentPage + 1} of $_totalPages',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios, color: _currentPage < _totalPages - 1 ? Colors.white : Colors.white.withOpacity(0.3)),
                    onPressed: _currentPage < _totalPages - 1 ? _nextPage : null,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
