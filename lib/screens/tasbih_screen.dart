import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zawiyah/providers/settings_provider.dart';
import '../models/tasbih_item.dart';
import 'tasbih_counter_screen.dart';

class TasbihScreen extends StatefulWidget {
  const TasbihScreen({Key? key}) : super(key: key);

  @override
  _TasbihScreenState createState() => _TasbihScreenState();
}

class _TasbihScreenState extends State<TasbihScreen> {
  final List<TasbihItem> _tasbihList = [];
  final _nameController = TextEditingController();
  final _countController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tasbihList.addAll([
      TasbihItem(arabicText: "سُبْحَانَ اللَّهِ", transliteration: "SubhanAllah"),
      TasbihItem(arabicText: "الْحَمْدُ لِلَّهِ", transliteration: "Alhamdulillah"),
      TasbihItem(arabicText: "اللَّهُ أَكْبَرُ", transliteration: "Allahu Akbar"),
      TasbihItem(arabicText: "لَا إِلَهَ إِلَّا اللَّهُ", transliteration: "La ilaha illAllah"),
      TasbihItem(arabicText: "أَسْتَغْفِرُ اللَّهَ", transliteration: "Astaghfirullah"),
    ]);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _countController.dispose();
    super.dispose();
  }

  void _navigateToCounter(TasbihItem item) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TasbihCounterScreen(tasbihItem: item)),
    );
    setState(() {});
  }

  void _showAddTasbihDialog(bool isDarkMode) {
    final dialogBgColor = isDarkMode ? const Color(0xFF1F1F1F) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final purpleColor = const Color(0xFF863ED5);

    _nameController.clear();
    _countController.clear();
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: dialogBgColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: purpleColor,
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0))),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  const Text('Add Tasbih', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.of(context).pop()),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(children: [
                  TextField(
                    controller: _nameController,
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      labelText: 'Tasbih Name',
                      labelStyle: TextStyle(color: textColor.withOpacity(0.7)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: textColor.withOpacity(0.3)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: purpleColor),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _countController,
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      labelText: 'Target Count',
                      labelStyle: TextStyle(color: textColor.withOpacity(0.7)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: textColor.withOpacity(0.3)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: purpleColor),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: purpleColor, minimumSize: const Size(double.infinity, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    onPressed: () {
                      final name = _nameController.text;
                      final count = int.tryParse(_countController.text) ?? 33;
                      if (name.isNotEmpty) {
                        setState(() {
                          _tasbihList.add(TasbihItem(arabicText: name, transliteration: '', targetCount: count));
                        });
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('ADD TASBIH', style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ]),
              ),
            ]),
          );
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
        final imageColor = isDarkMode ? purpleColor : null;

        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            title: const Text('TASBIH'),
            backgroundColor: bgColor,
            foregroundColor: textColor,
            elevation: 0,
            centerTitle: true,
            actions: [IconButton(icon: Icon(Icons.add_circle_outline, color: purpleColor), onPressed: () => _showAddTasbihDialog(isDarkMode))],
          ),
          body: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            itemCount: _tasbihList.length,
            itemBuilder: (context, index) {
              final item = _tasbihList[index];
              return InkWell(
                onTap: () => _navigateToCounter(item),
                borderRadius: BorderRadius.circular(15),
                child: Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  color: cardColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(children: [
                      // FIX: Themed image and improved layout
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: purpleColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            imageColor ?? purpleColor, 
                            BlendMode.srcIn,
                          ),
                          child: Image.asset('assets/images/t1.png', width: 35, height: 35, color: imageColor),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(item.arabicText, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'MeQuran', color: textColor)),
                          if (item.transliteration.isNotEmpty)
                            Text(item.transliteration, style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: textColor.withOpacity(0.7))),
                        ]),
                      ),
                      const SizedBox(width: 16),
                      // FIX: Improved counter UI
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isDarkMode ? purpleColor.withOpacity(0.2) : purpleColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Text(item.count.toString(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: purpleColor)),
                          Text("/${item.targetCount}", style: TextStyle(fontSize: 12, color: purpleColor.withOpacity(0.8))),
                        ]),
                      )
                    ]),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
