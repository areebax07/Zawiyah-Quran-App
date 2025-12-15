import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:zawiyah/providers/settings_provider.dart';
import '../models/tasbih_item.dart';

class TasbihCounterScreen extends StatefulWidget {
  final TasbihItem tasbihItem;

  const TasbihCounterScreen({Key? key, required this.tasbihItem}) : super(key: key);

  @override
  _TasbihCounterScreenState createState() => _TasbihCounterScreenState();
}

class _TasbihCounterScreenState extends State<TasbihCounterScreen> {
  late TasbihItem _item;

  @override
  void initState() {
    super.initState();
    _item = widget.tasbihItem;
  }

  void _increment() {
    setState(() {
      _item.count++;
      _item.cumulativeCount++;
      if (_item.count >= _item.targetCount) {
        _item.count = 0;
        _item.totalCount++;
        HapticFeedback.heavyImpact(); // Vibrate on completion
      }
    });
  }

  void _reset() {
    setState(() {
      _item.count = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        final isDarkMode = settings.isDarkMode;
        final bgColor = isDarkMode ? const Color(0xFF0D0216) : Colors.grey[100];
        final cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
        final textColor = isDarkMode ? Colors.white : Colors.black87;
        final purpleColor = const Color(0xFF863ED5);

        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            title: Text(_item.transliteration.isNotEmpty ? _item.transliteration : 'Tasbih Counter'),
            backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : purpleColor,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          body: Stack(
            children: [
              // FIX: Added subtle background texture
              Positioned.fill(
                child: Image.asset(
                  'assets/images/bggg.png',
                  fit: BoxFit.cover,
                  color: (isDarkMode ? Colors.white : Colors.black).withOpacity(0.03),
                  alignment: Alignment.center,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTopInfoCard(cardColor, textColor),
                  const Spacer(),
                  _buildCircularCounter(purpleColor, textColor),
                  const Spacer(flex: 2),
                  _buildControlButtons(purpleColor.withOpacity(0.8)),
                  const SizedBox(height: 50),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // FIX: Extracted widgets and applied theming
  Widget _buildTopInfoCard(Color cardColor, Color textColor) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4,
        color: cardColor,
        shadowColor: Colors.black.withOpacity(0.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text(
                _item.arabicText,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, fontFamily: 'MeQuran', color: textColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                _buildInfoText("SET COMPLETES", _item.totalCount.toString(), textColor),
                _buildInfoText("CUMULATIVE", _item.cumulativeCount.toString(), textColor),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoText(String label, String value, Color textColor) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: textColor.withOpacity(0.6), letterSpacing: 1.2)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor)),
      ],
    );
  }

  Widget _buildCircularCounter(Color purpleColor, Color textColor) {
    return GestureDetector(
      onTap: _increment,
      child: Container(
        width: 220,
        height: 220,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
          border: Border.all(color: purpleColor, width: 8),
           boxShadow: [
              BoxShadow(
                color: purpleColor.withOpacity(0.3),
                blurRadius: 25,
                spreadRadius: 5,
              ),
            ],
        ),
        child: Center(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
              children: [
                TextSpan(text: "${_item.count}", style: const TextStyle(fontSize: 60)),
                TextSpan(text: "/${_item.targetCount}", style: TextStyle(fontSize: 24, color: textColor.withOpacity(0.5))),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildControlButtons(Color iconColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildIconButton(Icons.vibration, "Vibrate", () => HapticFeedback.mediumImpact(), iconColor),
          _buildIconButton(Icons.refresh, "Reset", _reset, iconColor),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, String label, VoidCallback onPressed, Color color) {
    return Column(
      children: [
        IconButton(icon: Icon(icon, size: 30, color: color), onPressed: onPressed),
        Text(label, style: TextStyle(color: color, fontSize: 14)),
      ],
    );
  }
}
