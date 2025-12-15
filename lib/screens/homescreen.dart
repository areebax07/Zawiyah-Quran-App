import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zawiyah/providers/settings_provider.dart';
import 'package:zawiyah/screens/asma_ul_husna_screen.dart';
import 'package:zawiyah/screens/juz_list_screen.dart';
import 'package:zawiyah/screens/manzil_screen.dart';
import 'package:zawiyah/screens/dua_list_screen.dart';
import 'package:zawiyah/screens/prayer_times_screen.dart';
import 'package:zawiyah/screens/qibla_screen.dart';
import 'package:zawiyah/screens/quran_page_screen.dart';
import 'package:zawiyah/screens/ramadan_calendar_screen.dart';
import 'package:zawiyah/screens/surah_list_screen.dart';
import 'package:zawiyah/screens/tasbih_screen.dart';
import '../providers/quran_provider.dart';
import '../widgets/custom_drawer.dart';
import 'package:zawiyah/widgets/profile_drawer_right.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // FIX: The font size dialog now directly uses and updates the SettingsProvider.
  void _showFontSizeDialog() {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    final isDarkMode = settings.isDarkMode;
    final dialogBgColor = isDarkMode ? const Color(0xFF1F1F1F) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;

    showDialog(
      context: context,
      builder: (context) {
        // Use a Consumer here to rebuild the dialog contents when the provider changes.
        return Consumer<SettingsProvider>(
          builder: (context, settingsProvider, child) {
            return AlertDialog(
              backgroundColor: dialogBgColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              title: Text("Adjust Font Size", textAlign: TextAlign.center, style: TextStyle(color: textColor, fontSize: 18)),
              content: SizedBox(
                width: 200,
                height: 50,
                child: Slider(
                  value: settingsProvider.fontScale,
                  min: 0.8,
                  max: 1.5,
                  divisions: 7,
                  label: "${(settingsProvider.fontScale * 100).toStringAsFixed(0)}%",
                  onChanged: (double value) {
                    // Directly update the provider, which will cause the UI to rebuild.
                    settings.setFontScale(value);
                  },
                  activeColor: const Color(0xFF863ED5),
                  inactiveColor: isDarkMode ? Colors.white30 : Colors.black12,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('OK', style: TextStyle(color: isDarkMode ? Colors.white : const Color(0xFF863ED5), fontWeight: FontWeight.bold)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        final isDarkMode = settings.isDarkMode;
        const purpleColor = Color(0xFF863ED5);
        final bgColor = isDarkMode ? const Color(0xFF0D0216) : Colors.grey[100];
        final textColor = isDarkMode ? Colors.white : Colors.black87;
        
        final cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
        final shadowColor = isDarkMode ? Colors.black.withOpacity(0.4) : Colors.grey.withOpacity(0.2);
        final iconAndImageColor = isDarkMode ? purpleColor : Colors.black87;

        return Scaffold(
          backgroundColor: bgColor,
          drawer: CustomDrawer(onFontSizeTap: _showFontSizeDialog),
          endDrawer: const ProfileDrawerRight(),
          appBar: AppBar(
            backgroundColor: bgColor,
            foregroundColor: textColor,
            elevation: 0,
            title: Text("ZAWIYAH", style: TextStyle(fontFamily: 'Amiri', fontSize: 28, fontWeight: FontWeight.w600, color: textColor)),
            centerTitle: true,
            actions: [
              //new taskssss FFFFFFFFFFFF
              Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.account_circle),
                  onPressed: () => Scaffold.of(context).openEndDrawer(),
                ),
              ),
             // IconButton(icon: const Icon(Icons.card_giftcard, color: Colors.orangeAccent), onPressed: () {}),
              //IconButton(icon: const Icon(Icons.workspace_premium, color: Colors.amber), onPressed: () {}),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: _buildContinueReadingCard(context),
                  ),
                  const SizedBox(height: 20),
                  _buildQuickActions(context, isDarkMode, cardColor, shadowColor, iconAndImageColor),
                  const SizedBox(height: 20),
                  _buildFeatureList(context, isDarkMode, cardColor, shadowColor, textColor, iconAndImageColor),
                  const SizedBox(height: 20),
                  _buildSurahShortcutsList(context, isDarkMode, cardColor, shadowColor, iconAndImageColor),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: _buildBottomNavigationGrid(context, isDarkMode, cardColor, shadowColor, textColor, iconAndImageColor),
                  ),
                   const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContinueReadingCard(BuildContext context) {
    final quranProvider = context.watch<QuranProvider>();
    final lastRead = quranProvider.lastReadSurah;

    return Container(
        decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [Color(0xFFA060E2), Color(0xFF863ED5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [BoxShadow(color: const Color(0xFF863ED5).withOpacity(0.3), spreadRadius: 2, blurRadius: 15)]
        ),
        child: GestureDetector(
            onTap: () {
                if (lastRead != null) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => QuranPageScreen(surahNumber: lastRead['number'])));
                }
            },
            child: Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                const Text("Continue Reading", style: TextStyle(color: Colors.white, fontSize: 14)),
                                const SizedBox(height: 4),
                                Text(
                                    lastRead?['englishName'] ?? "Start Reading",
                                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                    children: [
                                        ElevatedButton(
                                            onPressed: () {
                                                if (lastRead != null) {
                                                    Navigator.push(context, MaterialPageRoute(builder: (context) => QuranPageScreen(surahNumber: lastRead['number'])));
                                                }
                                            },
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.white.withOpacity(0.9),
                                                foregroundColor: const Color(0xFF863ED5),
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                            ),
                                            child: const Text("Resume"),
                                        ),
                                        const SizedBox(width: 8),
                                        OutlinedButton.icon(
                                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SurahListScreen())),
                                            icon: const Icon(Icons.visibility_outlined, size: 18),
                                            label: const Text("Quran"),
                                            style: OutlinedButton.styleFrom(
                                                foregroundColor: Colors.white,
                                                side: const BorderSide(color: Colors.white54),
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                            ),
                                        ),
                                    ],
                                )
                            ],
                        ),
                        Image.asset('assets/images/newqi.png', width: 110, height: 120, fit: BoxFit.contain, errorBuilder: (c, o, s) => const SizedBox(width: 150, height: 120)),
                    ],
                ),
            ),
        ),
    );
  }

  Widget _buildQuickActions(BuildContext context, bool isDarkMode, Color cardColor, Color shadowColor, Color iconColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: shadowColor, spreadRadius: 1, blurRadius: 8)]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildQuickActionItem(context, icon: Icons.book_outlined, title: "Read Quran", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SurahListScreen())), isDarkMode: isDarkMode, iconColor: iconColor),
          _buildQuickActionItem(context, icon: Icons.headset_outlined, title: "Audio", onTap: () {}, isDarkMode: isDarkMode, iconColor: iconColor),
          _buildQuickActionItem(context, icon: Icons.list_alt_outlined, title: "Parah", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const JuzListScreen())), isDarkMode: isDarkMode, iconColor: iconColor),
          _buildQuickActionItem(context, icon: Icons.bookmark_border_outlined, title: "Bookmark", onTap: () {}, isDarkMode: isDarkMode, iconColor: iconColor),
        ],
      ),
    );
  }

  Widget _buildQuickActionItem(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap, required bool isDarkMode, required Color iconColor}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 28),
            const SizedBox(height: 8),
            Text(title, style: TextStyle(fontSize: 12, color: isDarkMode ? Colors.white70 : Colors.black87)),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureList(BuildContext context, bool isDarkMode, Color cardColor, Color shadowColor, Color textColor, Color imageColor) {
    final features = [
      _buildFeatureItem(context, imagePath: 'assets/images/pt2.png', title: "Prayer Time", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PrayerTimesScreen())), isDarkMode: isDarkMode, cardColor: cardColor, shadowColor: shadowColor, textColor: textColor, imageColor: imageColor),
      _buildFeatureItem(context, imagePath: 'assets/images/d1.png', title: "Dua", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DuaListScreen())), isDarkMode: isDarkMode, cardColor: cardColor, shadowColor: shadowColor, textColor: textColor, imageColor: imageColor),
      _buildFeatureItem(context, imagePath: 'assets/images/t1.png', title: "Tasbih", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TasbihScreen())), isDarkMode: isDarkMode, cardColor: cardColor, shadowColor: shadowColor, textColor: textColor, imageColor: imageColor),
      _buildFeatureItem(context, imagePath: 'assets/images/r2.png', title: "Ramadan", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RamadanCalendarScreen())), isDarkMode: isDarkMode, cardColor: cardColor, shadowColor: shadowColor, textColor: textColor, imageColor: imageColor),
      _buildFeatureItem(context, imagePath: 'assets/images/q1.png', title: "Qibla", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const QiblaScreen())), isDarkMode: isDarkMode, cardColor: cardColor, shadowColor: shadowColor, textColor: textColor, imageColor: imageColor),
      _buildFeatureItem(context, imagePath: 'assets/images/m1.png', title: "Manzil", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ManzilScreen())), isDarkMode: isDarkMode, cardColor: cardColor, shadowColor: shadowColor, textColor: textColor, imageColor: imageColor),
      _buildFeatureItem(context, imagePath: 'assets/images/asmaulhusna.png', title: "Asma ul Husna", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AsmaUlHusnaScreen())), isDarkMode: isDarkMode, cardColor: cardColor, shadowColor: shadowColor, textColor: textColor, imageColor: imageColor),
    ];

    return SizedBox(
        height: 100,
        child: ListView.builder(itemCount: features.length, scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 12), itemBuilder: (context, index) => features[index]));
  }

  Widget _buildFeatureItem(BuildContext context, {required String imagePath, required String title, required VoidCallback onTap, required bool isDarkMode, required Color cardColor, required Color shadowColor, required Color textColor, required Color imageColor}) {
    Widget imageWidget = Image.asset(imagePath, width: 40, height: 40, fit: BoxFit.contain, errorBuilder: (c, o, s) => const SizedBox(width: 40, height: 40));

    if (isDarkMode) {
      imageWidget = ColorFiltered(
        colorFilter: ColorFilter.mode(imageColor, BlendMode.srcIn),
        child: imageWidget,
      );
    }

    return Container(
        width: 80,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: shadowColor, spreadRadius: 1, blurRadius: 8)]
        ),
      child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            imageWidget,
            const SizedBox(height: 8),
            Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: textColor.withOpacity(0.9))),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildSurahShortcutsList(BuildContext context, bool isDarkMode, Color cardColor, Color shadowColor, Color imageColor) {
    return SizedBox(
      height: 80,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          _buildSurahShortcutItem(context, imagePath: "assets/images/y2.png", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const QuranPageScreen(surahNumber: 36))), isDarkMode: isDarkMode, cardColor: cardColor, shadowColor: shadowColor, imageColor: imageColor),
          _buildSurahShortcutItem(context, imagePath: "assets/images/rh2.png", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const QuranPageScreen(surahNumber: 55))), isDarkMode: isDarkMode, cardColor: cardColor, shadowColor: shadowColor, imageColor: imageColor),
          _buildSurahShortcutItem(context, imagePath: "assets/images/w1.png", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const QuranPageScreen(surahNumber: 56))), isDarkMode: isDarkMode, cardColor: cardColor, shadowColor: shadowColor, imageColor: imageColor),
          _buildSurahShortcutItem(context, imagePath: "assets/images/k1.png", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const QuranPageScreen(surahNumber: 18))), isDarkMode: isDarkMode, cardColor: cardColor, shadowColor: shadowColor, imageColor: imageColor),
          _buildSurahShortcutItem(context, imagePath: "assets/images/mu1.png", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const QuranPageScreen(surahNumber: 67))), isDarkMode: isDarkMode, cardColor: cardColor, shadowColor: shadowColor, imageColor: imageColor),
        ],
      ),
    );
  }

  Widget _buildSurahShortcutItem(BuildContext context, {required String imagePath, required VoidCallback onTap, required bool isDarkMode, required Color cardColor, required Color shadowColor, required Color imageColor}) {
    Widget imageWidget = Image.asset(imagePath, fit: BoxFit.cover, errorBuilder: (c, o, s) => const SizedBox(width: 120, height: 80));

    if (isDarkMode) {
      imageWidget = ColorFiltered(
        colorFilter: ColorFilter.mode(imageColor, BlendMode.srcIn),
        child: imageWidget,
      );
    }

    return Container(
      width: 120,
      height: 80,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: shadowColor, spreadRadius: 1, blurRadius: 8)]
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: imageWidget,
        ),
      ),
    );
  }

  Widget _buildBottomNavigationGrid(BuildContext context, bool isDarkMode, Color cardColor, Color shadowColor, Color textColor, Color imageColor) {
    final items = [
      _buildGridItem(context, imagePath: 'assets/images/qic.png', label: "Quran", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SurahListScreen())), isDarkMode: isDarkMode, cardColor: cardColor, shadowColor: shadowColor, textColor: textColor, imageColor: imageColor),
      _buildGridItem(context, imagePath: 'assets/images/headphone.png', label: "Surah (Audio)", onTap: () {}, isDarkMode: isDarkMode, cardColor: cardColor, shadowColor: shadowColor, textColor: textColor, imageColor: imageColor),
      _buildGridItem(context, imagePath: 'assets/images/qur.png', label: "Parah", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const JuzListScreen())), isDarkMode: isDarkMode, cardColor: cardColor, shadowColor: shadowColor, textColor: textColor, imageColor: imageColor),
      _buildGridItem(context, imagePath: 'assets/images/bm.png', label: "Bookmark", onTap: () {}, isDarkMode: isDarkMode, cardColor: cardColor, shadowColor: shadowColor, textColor: textColor, imageColor: imageColor),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.6,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
      ),
      itemBuilder: (context, index) {
        return items[index];
      },
    );
  }

  Widget _buildGridItem(BuildContext context, {required String imagePath, required String label, required VoidCallback onTap, required bool isDarkMode, required Color cardColor, required Color shadowColor, required Color textColor, required Color imageColor}) {
    Widget imageWidget = Image.asset(imagePath, width: 70, height: 70, errorBuilder: (c, o, s) => const SizedBox(width: 40, height: 40));

    // if (isDarkMode) {
    //   imageWidget = ColorFiltered(
    //     colorFilter: ColorFilter.mode(imageColor, BlendMode.srcIn),
    //     child: imageWidget,
    //   );
    // }
    
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: shadowColor, spreadRadius: 1, blurRadius: 8)]
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            imageWidget,
            const SizedBox(height: 12),
            Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: textColor.withOpacity(0.8))),
          ],
        ),
      ),
    );
  }
}
