import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screen_brightness/screen_brightness.dart';
//import 'package:share_plus/share_plus.dart';
import '../providers/settings_provider.dart';
import '../screens/language_screen.dart';

class CustomDrawer extends StatefulWidget {
  final VoidCallback? onFontSizeTap;

  const CustomDrawer({Key? key, this.onFontSizeTap}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  double _currentBrightness = 1.0;
  bool _remindersEnabled = true;

  @override
  void initState() {
    super.initState();
    _initializeBrightness();
  }

  Future<void> _initializeBrightness() async {
    try {
      _currentBrightness = await ScreenBrightness().current;
      if(mounted) setState(() {});
    } catch (e) {
      print(e); // Handle error
    }
  }

  void _showBrightnessDialog() {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    final isDarkMode = settings.isDarkMode;
    final dialogBgColor = isDarkMode ? const Color(0xFF1F1F1F) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: dialogBgColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              title: Text('Adjust Brightness', textAlign: TextAlign.center, style: TextStyle(color: textColor, fontSize: 18)),
              content: SizedBox(
                width: 200,
                height: 50,
                child: Slider(
                  value: _currentBrightness,
                  min: 0.1, 
                  max: 1.0,
                  onChanged: (double value) {
                     setState(() {
                       _currentBrightness = value;
                       ScreenBrightness().setScreenBrightness(value);
                     });
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

  // FIX: Restored the Rate Us and Star Rating dialogs
  void _showStarRatingDialog(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    final isDarkMode = settings.isDarkMode;
    final dialogBgColor = isDarkMode ? const Color(0xFF1F1F1F) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    int rating = 0;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: dialogBgColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              title: Text('Rate Your Experience', textAlign: TextAlign.center, style: TextStyle(color: textColor)),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < rating ? Icons.star : Icons.star_border,
                      color: const Color(0xFF863ED5),
                      size: 32,
                    ),
                    onPressed: () {
                      setState(() => rating = index + 1);
                    },
                  );
                }),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('CANCEL', style: TextStyle(color: textColor.withOpacity(0.7)))),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(), // Submit logic here
                  child: const Text('SUBMIT', style: TextStyle(color: Color(0xFF863ED5), fontWeight: FontWeight.bold)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showRateUsDialog(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    final isDarkMode = settings.isDarkMode;
    final dialogBgColor = isDarkMode ? const Color(0xFF1F1F1F) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: dialogBgColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text('Rate Our App', style: TextStyle(color: textColor)),
        content: Text('If you enjoy this app, please take a moment to rate it.', style: TextStyle(color: textColor.withOpacity(0.7))),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('CANCEL', style: TextStyle(color: textColor.withOpacity(0.7)))),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showStarRatingDialog(context);
            },
            child: const Text('RATE', style: TextStyle(color: Color(0xFF863ED5), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // FIX: Restored the Feedback dialog
  void _showFeedbackDialog(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    final isDarkMode = settings.isDarkMode;
    final dialogBgColor = isDarkMode ? const Color(0xFF1F1F1F) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: dialogBgColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text('Send Feedback', style: TextStyle(color: textColor)),
        content: TextField(
          style: TextStyle(color: textColor),
          decoration: InputDecoration(
            hintText: 'Describe your issue or suggestion...',
            hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF863ED5))),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: textColor.withOpacity(0.3))),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('CANCEL', style: TextStyle(color: textColor.withOpacity(0.7)))),
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('SEND', style: TextStyle(color: Color(0xFF863ED5), fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        final isDarkMode = settings.isDarkMode;
        final bgColor = isDarkMode ? const Color(0xFF0D0216) : Colors.white;
        final textColor = isDarkMode ? Colors.white : Colors.black87;
        final iconColor = isDarkMode ? Colors.white70 : Colors.grey[700];
        final purpleColor = const Color(0xFF863ED5);
        final dividerColor = isDarkMode ? Colors.white24 : const Color(0xFFEEEEEE);

        return Drawer(
          backgroundColor: bgColor,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              _buildDrawerHeader(bgColor, textColor),
              const SizedBox(height: 10),
              _buildDrawerItem(
                icon: Icons.brightness_6_outlined,
                title: 'Theme Mode',
                iconColor: iconColor,
                textColor: textColor,
                trailing: Switch(
                  value: settings.isDarkMode,
                  onChanged: (value) => settings.toggleTheme(value),
                  activeColor: purpleColor,
                ),
                onTap: () {},
              ),
              Divider(color: dividerColor, indent: 16, endIndent: 16),
              _buildDrawerItem(
                icon: Icons.format_size_outlined,
                title: 'Font Size',
                iconColor: iconColor,
                textColor: textColor,
                onTap: () {
                  Navigator.pop(context);
                  widget.onFontSizeTap?.call();
                },
              ),
              Divider(color: dividerColor, indent: 16, endIndent: 16),
              _buildDrawerItem(
                icon: Icons.brightness_medium_outlined,
                title: 'Brightness',
                iconColor: iconColor,
                textColor: textColor,
                onTap: () {
                  Navigator.pop(context);
                  _showBrightnessDialog();
                },
              ),
              Divider(color: dividerColor, indent: 16, endIndent: 16),
              _buildDrawerItem(
                icon: Icons.notifications_active_outlined,
                title: 'Daily Reminders',
                iconColor: iconColor,
                textColor: textColor,
                trailing: Switch(
                  value: _remindersEnabled,
                  onChanged: (val) {
                    setState(() {
                      _remindersEnabled = val;
                    });
                  },
                  activeColor: purpleColor,
                ),
                onTap: () {},
              ),
              Divider(color: dividerColor, indent: 16, endIndent: 16),
              _buildDrawerItem(
                icon: Icons.language_outlined,
                title: 'Language',
                iconColor: iconColor,
                textColor: textColor,
                onTap: () {
                   Navigator.pop(context);
                   Navigator.push(context, MaterialPageRoute(builder: (context) => const LanguageScreen()));
                },
              ),
              Divider(color: dividerColor, indent: 16, endIndent: 16),
              _buildDrawerItem(
                icon: Icons.share_outlined,
                title: 'Share App',
                iconColor: iconColor,
                textColor: textColor,
                onTap: () {
                //  Share.share('Check out Zawiyah - a beautiful Islamic app! https://play.google.com/store/apps');
                },
              ),
              Divider(color: dividerColor, indent: 16, endIndent: 16),
              _buildDrawerItem(
                icon: Icons.star_border,
                title: 'Rate Us',
                iconColor: iconColor,
                textColor: textColor,
                onTap: () => _showRateUsDialog(context),
              ),
              Divider(color: dividerColor, indent: 16, endIndent: 16),
              _buildDrawerItem(
                icon: Icons.feedback_outlined,
                title: 'Feedback',
                iconColor: iconColor,
                textColor: textColor,
                onTap: () => _showFeedbackDialog(context),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDrawerHeader(Color bgColor, Color textColor) {
    return DrawerHeader(
      decoration: BoxDecoration(color: bgColor),
      child: Center(
        child: Text(
          'ZAWIYAH',
          style: TextStyle(
            fontFamily: 'Amiri',
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required Color? iconColor,
    required Color textColor,
    Widget? trailing,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title, style: TextStyle(fontSize: 16, color: textColor)),
      trailing: trailing,
      onTap: onTap,
      splashColor: const Color(0xFF863ED5).withOpacity(0.2),
    );
  }
}
